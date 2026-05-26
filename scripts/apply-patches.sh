#!/usr/bin/env bash
set -euo pipefail

MODE="${1:---check}"
PATCH_ROOT="patches.d"
PENDING_DIR="$PATCH_ROOT/pending"
APPLIED_DIR="$PATCH_ROOT/applied"
FAILED_DIR="$PATCH_ROOT/failed"
CHECKLIST="$PATCH_ROOT/patches_checklist.yaml"
LEGACY_TSV_CHECKLIST="$PATCH_ROOT/patches_checklist.tsv"

usage() {
  cat <<'USAGE'
usage: scripts/apply-patches.sh [--check|--apply]

Applies pending repository patches from patches.d/pending in lexical order.

Patch filenames SHOULD begin with a 6-digit ordinal:

  000001-example.patch

Modes:
  --check   verify pending patches without applying them
  --apply   apply pending patches, commit each patch, move it to applied/, and update checklist
USAGE
}

case "$MODE" in
  --check|--apply) ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

require_repo_root() {
  if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
    echo "error: not inside a git repository" >&2
    exit 1
  fi

  local root
  root="$(git rev-parse --show-toplevel)"
  if [[ "$PWD" != "$root" ]]; then
    echo "error: run from repository root: $root" >&2
    exit 1
  fi
}

require_python_yaml() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "error: python3 not found" >&2
    echo "hint: scripts/setup-patch-tools-debian.sh --install" >&2
    exit 1
  fi

  if ! python3 - <<'PY' >/dev/null 2>&1
import yaml
PY
  then
    echo "error: Python package 'yaml' could not be imported" >&2
    echo "hint: install PyYAML, or on Debian/WSL run:" >&2
    echo "      scripts/setup-patch-tools-debian.sh --install" >&2
    exit 1
  fi
}

require_clean_tree() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "error: working tree has uncommitted changes" >&2
    echo "commit or stash them before applying queued patches" >&2
    exit 1
  fi
}

init_dirs() {
  mkdir -p "$PENDING_DIR" "$APPLIED_DIR" "$FAILED_DIR"
  if [[ ! -f "$CHECKLIST" ]]; then
    cat > "$CHECKLIST" <<'YAML'
patches: []
YAML
  fi
}

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "error: need sha256sum or shasum" >&2
    exit 1
  fi
}

patch_id_from_path() {
  basename "$1" | sed -E 's/^([0-9]{6}).*$/\1/'
}

patch_desc_from_path() {
  local base stem
  base="$(basename "$1")"
  stem="${base%.patch}"
  echo "$stem" | sed -E 's/^[0-9]{6}-//; s/-/ /g'
}

is_applied() {
  local id="$1"
  python3 - "$CHECKLIST" "$id" <<'PY'
import sys
from pathlib import Path
import yaml

path = Path(sys.argv[1])
patch_id = sys.argv[2]
if not path.exists():
    raise SystemExit(1)

data = yaml.safe_load(path.read_text()) or {}
for row in data.get("patches", []):
    if str(row.get("id", "")) == patch_id and row.get("status") == "applied":
        raise SystemExit(0)
raise SystemExit(1)
PY
}

upsert_checklist_entry() {
  local id="$1" file="$2" status="$3" applied_at="$4" hash="$5" desc="$6"
  python3 - "$CHECKLIST" "$id" "$file" "$status" "$applied_at" "$hash" "$desc" <<'PY'
import sys
from pathlib import Path
import yaml

path = Path(sys.argv[1])
entry = {
    "id": sys.argv[2],
    "file": sys.argv[3],
    "status": sys.argv[4],
    "applied_at": sys.argv[5],
    "sha256": sys.argv[6],
    "description": sys.argv[7],
}

data = yaml.safe_load(path.read_text()) if path.exists() else None
if not isinstance(data, dict):
    data = {}
patches = data.get("patches")
if not isinstance(patches, list):
    patches = []

patches = [row for row in patches if str(row.get("id", "")) != entry["id"]]
patches.append(entry)
patches.sort(key=lambda row: str(row.get("id", "")))
data["patches"] = patches

path.write_text(yaml.safe_dump(data, sort_keys=False, allow_unicode=True))
PY
}

add_patch_note() {
  local commit_sha="$1" id="$2" applied_path="$3" hash="$4" applied_at="$5" desc="$6"
  if ! git notes add -f -m "patch_id=$id
commit_sha=$commit_sha
patch_file=$applied_path
patch_sha256=$hash
applied_at=$applied_at
description=$desc" "$commit_sha" >/dev/null 2>&1; then
    echo "warning: failed to write git note for patch $id" >&2
  fi
}

pending_patches() {
  find "$PENDING_DIR" -maxdepth 1 -type f -name '[0-9][0-9][0-9][0-9][0-9][0-9]-*.patch' | sort
}

check_patch() {
  local patch="$1"
  git apply --check "$patch"
}

apply_one_patch() {
  local patch="$1"
  local id desc hash applied_path applied_at commit_sha commit_msg

  require_clean_tree

  id="$(patch_id_from_path "$patch")"
  desc="$(patch_desc_from_path "$patch")"
  hash="$(sha256_file "$patch")"
  applied_path="$APPLIED_DIR/$(basename "$patch")"

  if is_applied "$id"; then
    echo "skip: $id already marked applied"
    return 0
  fi

  echo "check: $patch"
  if ! git apply --check "$patch"; then
    mkdir -p "$FAILED_DIR"
    mv "$patch" "$FAILED_DIR/$(basename "$patch")"
    upsert_checklist_entry "$id" "$FAILED_DIR/$(basename "$patch")" "failed" "" "$hash" "$desc"
    git add "$CHECKLIST" "$FAILED_DIR/$(basename "$patch")" || true
    git commit -m "Record failed patch $id" || true
    echo "error: patch failed check and was moved to $FAILED_DIR" >&2
    exit 1
  fi

  echo "apply: $patch"
  git apply "$patch"

  mkdir -p "$APPLIED_DIR"
  mv "$patch" "$applied_path"

  applied_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  upsert_checklist_entry "$id" "$applied_path" "applied" "$applied_at" "$hash" "$desc"

  git add -A
  commit_msg="Apply patch $id: $desc"
  git commit -m "$commit_msg"
  commit_sha="$(git rev-parse HEAD)"
  add_patch_note "$commit_sha" "$id" "$applied_path" "$hash" "$applied_at" "$desc"

  echo "applied: $id -> $commit_sha"
  echo "note: git notes are local unless pushed with: git push origin refs/notes/commits"
}

main() {
  require_repo_root
  require_python_yaml
  init_dirs

  if [[ -f "$LEGACY_TSV_CHECKLIST" ]]; then
    echo "note: legacy TSV checklist still exists at $LEGACY_TSV_CHECKLIST; YAML checklist is authoritative"
  fi

  mapfile -t patches < <(pending_patches)
  if [[ "${#patches[@]}" -eq 0 ]]; then
    echo "no pending patches"
    exit 0
  fi

  if [[ "$MODE" == "--check" ]]; then
    for patch in "${patches[@]}"; do
      id="$(patch_id_from_path "$patch")"
      if is_applied "$id"; then
        echo "skip: $id already marked applied"
        continue
      fi
      echo "check: $patch"
      check_patch "$patch"
    done
    echo "all pending patches check cleanly"
    exit 0
  fi

  require_clean_tree
  for patch in "${patches[@]}"; do
    apply_one_patch "$patch"
  done
}

main
