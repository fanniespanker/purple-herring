#!/usr/bin/env bash
set -euo pipefail

MODE="${1:---check}"
PATCH_ROOT="patches.d"
PENDING_DIR="$PATCH_ROOT/pending"
APPLIED_DIR="$PATCH_ROOT/applied"
FAILED_DIR="$PATCH_ROOT/failed"
CHECKLIST="$PATCH_ROOT/patches_checklist.tsv"

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
    printf 'patch_id\tpatch_file\tstatus\tapplied_at\tcommit_sha\tsha256\tdescription\n' > "$CHECKLIST"
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
  [[ -f "$CHECKLIST" ]] && awk -F '\t' -v id="$id" 'NR>1 && $1==id && $3=="applied" { found=1 } END { exit found ? 0 : 1 }' "$CHECKLIST"
}

append_or_replace_checklist_row() {
  local id="$1" file="$2" status="$3" applied_at="$4" commit_sha="$5" hash="$6" desc="$7"
  local tmp
  tmp="$(mktemp)"
  awk -F '\t' -v OFS='\t' -v id="$id" 'NR==1 { print; next } $1!=id { print }' "$CHECKLIST" > "$tmp"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$file" "$status" "$applied_at" "$commit_sha" "$hash" "$desc" >> "$tmp"
  mv "$tmp" "$CHECKLIST"
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
    append_or_replace_checklist_row "$id" "$FAILED_DIR/$(basename "$patch")" "failed" "" "" "$hash" "$desc"
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
  append_or_replace_checklist_row "$id" "$applied_path" "applied" "$applied_at" "PENDING_COMMIT" "$hash" "$desc"

  git add -A
  commit_msg="Apply patch $id: $desc"
  git commit -m "$commit_msg"
  commit_sha="$(git rev-parse HEAD)"

  append_or_replace_checklist_row "$id" "$applied_path" "applied" "$applied_at" "$commit_sha" "$hash" "$desc"
  git add "$CHECKLIST"
  git commit --amend --no-edit

  echo "applied: $id -> $(git rev-parse HEAD)"
}

main() {
  require_repo_root
  init_dirs

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
