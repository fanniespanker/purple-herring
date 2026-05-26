#!/usr/bin/env bash
set -euo pipefail

MODE="--check"
WORKDIR=""
CONFIG_FILE=""
GENERATE_CONFIG=0
FORCE_CONFIG=0
CREATE_NOTES=1
PUSH_NOTES=1
FORCE_TSV=0
PATCH_ROOT="patches.d"
PENDING_DIR=""
APPLIED_DIR=""
FAILED_DIR=""
YAML_CHECKLIST=""
TSV_CHECKLIST=""
CHECKLIST=""
CHECKLIST_FORMAT=""
NOTES_REMOTE="origin"
NOTES_REF="refs/notes/commits"
ID_NUMBER_LENGTH=6
ALLOW_TSV_FALLBACK=1
PROMPT_FOR_FALLBACK=1
REQUIRE_CLEAN_TREE=1

CLI_PATCH_ROOT=0
CLI_PENDING_DIR=0
CLI_APPLIED_DIR=0
CLI_FAILED_DIR=0
CLI_YAML_CHECKLIST=0
CLI_TSV_CHECKLIST=0

usage() {
  cat <<'USAGE'
usage: scripts/apply-patches.sh [--check|--apply] [options]
       scripts/apply-patches.sh --generate-config [options]

Applies pending repository patches from the configured pending directory in lexical order.

Default workspace/config resolution:
  1. --working-dir DIR, if supplied
  2. current repository root, if run inside a git repo
  3. $HOME, if run outside a git repo

Default config path:
  .apply-patches.yaml, or .apply-patches if that file already exists

Patch filenames SHOULD begin with a numeric ordinal whose length is configured by
patches.id_number_length. The default is 6:

  000001-example.patch

Modes:
  --check             verify pending patches without applying them
  --apply             apply pending patches, commit each patch, move it to applied/, and update checklist
  --generate-config   write effective configuration and exit

Config/workspace:
  --working-dir DIR   use DIR as patch workspace
  --config FILE       read/write config file path
  --force             allow --generate-config to overwrite an existing config file

Directory/checklist options:
  --patch-root DIR        set patch queue root; implies conventional child paths unless overridden
  --pending-dir DIR       set pending patch directory
  --applied-dir DIR       set applied patch directory
  --failed-dir DIR        set failed patch directory
  --checklist-yaml FILE   set YAML checklist path
  --checklist-tsv FILE    set TSV fallback checklist path
  --id-number-length N    set patch id digit count, default 6
  --id-width N            alias for --id-number-length
  --fallback-tsv          use TSV checklist instead of YAML without prompting

Git note options:
  --no-notes              do not create git notes for patch commits
  --no-push-notes         create local git notes, but do not push notes
  --notes-remote NAME     set notes remote, default origin
  --notes-ref REF         set notes ref, default refs/notes/commits
USAGE
}

parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --check|--apply) MODE="$1" ;;
      --generate-config|--generate-dot-file) GENERATE_CONFIG=1 ;;
      --working-dir)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --working-dir requires a path" >&2; exit 2; }
        WORKDIR="$1" ;;
      --config)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --config requires a path" >&2; exit 2; }
        CONFIG_FILE="$1" ;;
      --force) FORCE_CONFIG=1 ;;
      --fallback-tsv) FORCE_TSV=1 ;;
      --patch-root)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --patch-root requires a directory" >&2; exit 2; }
        PATCH_ROOT="$1"; CLI_PATCH_ROOT=1 ;;
      --pending-dir|--pending)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --pending-dir requires a directory" >&2; exit 2; }
        PENDING_DIR="$1"; CLI_PENDING_DIR=1 ;;
      --applied-dir|--applied)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --applied-dir requires a directory" >&2; exit 2; }
        APPLIED_DIR="$1"; CLI_APPLIED_DIR=1 ;;
      --failed-dir|--failed)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --failed-dir requires a directory" >&2; exit 2; }
        FAILED_DIR="$1"; CLI_FAILED_DIR=1 ;;
      --checklist-yaml)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --checklist-yaml requires a path" >&2; exit 2; }
        YAML_CHECKLIST="$1"; CLI_YAML_CHECKLIST=1 ;;
      --checklist-tsv)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --checklist-tsv requires a path" >&2; exit 2; }
        TSV_CHECKLIST="$1"; CLI_TSV_CHECKLIST=1 ;;
      --id-number-length|--id-width)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --id-number-length requires a number" >&2; exit 2; }
        ID_NUMBER_LENGTH="$1" ;;
      --no-notes) CREATE_NOTES=0; PUSH_NOTES=0 ;;
      --no-push-notes) PUSH_NOTES=0 ;;
      --notes-remote)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --notes-remote requires a remote name" >&2; exit 2; }
        NOTES_REMOTE="$1" ;;
      --notes-ref)
        shift; [[ "$#" -gt 0 ]] || { echo "error: --notes-ref requires a ref" >&2; exit 2; }
        NOTES_REF="$1" ;;
      -h|--help) usage; exit 0 ;;
      *) usage >&2; exit 2 ;;
    esac
    shift
  done
}

python_yaml_available() {
  command -v python3 >/dev/null 2>&1 && python3 - <<'PY' >/dev/null 2>&1
import yaml
PY
}

bool_word() {
  if [[ "$1" == "1" || "$1" == "true" || "$1" == "True" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

resolve_workspace() {
  if [[ -n "$WORKDIR" ]]; then
    mkdir -p "$WORKDIR"
    cd "$WORKDIR"
  elif git rev-parse --show-toplevel >/dev/null 2>&1; then
    cd "$(git rev-parse --show-toplevel)"
  else
    cd "$HOME"
  fi

  if [[ -z "$CONFIG_FILE" ]]; then
    if [[ -f ".apply-patches" && ! -f ".apply-patches.yaml" ]]; then
      CONFIG_FILE=".apply-patches"
    else
      CONFIG_FILE=".apply-patches.yaml"
    fi
  fi
}

load_config_if_present() {
  [[ -f "$CONFIG_FILE" ]] || return 0

  if ! python_yaml_available; then
    echo "warning: config file exists but python3 + PyYAML are unavailable: $CONFIG_FILE" >&2
    echo "hint: scripts/setup-patch-tools-debian.sh --install" >&2
    return 0
  fi

  local assignments
  assignments="$(python3 - "$CONFIG_FILE" <<'PY'
import shlex
import sys
from pathlib import Path
import yaml

path = Path(sys.argv[1])
data = yaml.safe_load(path.read_text()) or {}

def v(section, key):
    return data.get(section, {}).get(key)

def b(section, key):
    value = v(section, key)
    if value is None:
        return None
    return "1" if bool(value) else "0"

id_len = v("patches", "id_number_length")
if id_len is None:
    id_len = v("patches", "id_width")

mapping = {
    "PATCH_ROOT": v("patches", "root"),
    "PENDING_DIR": v("patches", "pending_dir"),
    "APPLIED_DIR": v("patches", "applied_dir"),
    "FAILED_DIR": v("patches", "failed_dir"),
    "ID_NUMBER_LENGTH": id_len,
    "YAML_CHECKLIST": v("checklist", "yaml_path"),
    "TSV_CHECKLIST": v("checklist", "tsv_path"),
    "ALLOW_TSV_FALLBACK": b("checklist", "allow_tsv_fallback"),
    "PROMPT_FOR_FALLBACK": b("checklist", "prompt_for_fallback"),
    "CREATE_NOTES": b("notes", "create"),
    "PUSH_NOTES": b("notes", "push"),
    "NOTES_REMOTE": v("notes", "remote"),
    "NOTES_REF": v("notes", "ref"),
    "REQUIRE_CLEAN_TREE": b("git", "require_clean_tree"),
}
for key, value in mapping.items():
    if value is not None:
        print(f"{key}={shlex.quote(str(value))}")
PY
)"

  if [[ -n "$assignments" ]]; then
    eval "$assignments"
  fi
}

derive_paths_from_root() {
  if [[ -z "$PENDING_DIR" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_PENDING_DIR" -eq 0 ) ]]; then
    PENDING_DIR="$PATCH_ROOT/pending"
  fi
  if [[ -z "$APPLIED_DIR" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_APPLIED_DIR" -eq 0 ) ]]; then
    APPLIED_DIR="$PATCH_ROOT/applied"
  fi
  if [[ -z "$FAILED_DIR" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_FAILED_DIR" -eq 0 ) ]]; then
    FAILED_DIR="$PATCH_ROOT/failed"
  fi
  if [[ -z "$YAML_CHECKLIST" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_YAML_CHECKLIST" -eq 0 ) ]]; then
    YAML_CHECKLIST="$PATCH_ROOT/patches_checklist.yaml"
  fi
  if [[ -z "$TSV_CHECKLIST" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_TSV_CHECKLIST" -eq 0 ) ]]; then
    TSV_CHECKLIST="$PATCH_ROOT/patches_checklist.tsv"
  fi
}

validate_id_number_length() {
  if ! [[ "$ID_NUMBER_LENGTH" =~ ^[1-9][0-9]*$ ]]; then
    echo "error: id_number_length must be a positive integer, got: $ID_NUMBER_LENGTH" >&2
    exit 2
  fi
}

write_config() {
  if [[ -e "$CONFIG_FILE" && "$FORCE_CONFIG" -ne 1 ]]; then
    echo "error: config file already exists: $CONFIG_FILE" >&2
    echo "hint: rerun with --force to overwrite" >&2
    exit 1
  fi

  cat > "$CONFIG_FILE" <<YAML
patches:
  root: "$PATCH_ROOT"
  pending_dir: "$PENDING_DIR"
  applied_dir: "$APPLIED_DIR"
  failed_dir: "$FAILED_DIR"
  id_number_length: $ID_NUMBER_LENGTH

checklist:
  preferred_format: "yaml"
  yaml_path: "$YAML_CHECKLIST"
  tsv_path: "$TSV_CHECKLIST"
  allow_tsv_fallback: $(bool_word "$ALLOW_TSV_FALLBACK")
  prompt_for_fallback: $(bool_word "$PROMPT_FOR_FALLBACK")

notes:
  create: $(bool_word "$CREATE_NOTES")
  push: $(bool_word "$PUSH_NOTES")
  remote: "$NOTES_REMOTE"
  ref: "$NOTES_REF"

git:
  require_clean_tree: $(bool_word "$REQUIRE_CLEAN_TREE")
YAML

  echo "wrote config: $(pwd)/$CONFIG_FILE"
}

choose_checklist_backend() {
  if [[ "$FORCE_TSV" -eq 1 ]]; then
    CHECKLIST_FORMAT="tsv"; CHECKLIST="$TSV_CHECKLIST"; return 0
  fi
  if python_yaml_available; then
    CHECKLIST_FORMAT="yaml"; CHECKLIST="$YAML_CHECKLIST"; return 0
  fi
  echo "warning: python3 + PyYAML are not available; YAML checklist support is unavailable" >&2
  echo "hint: scripts/setup-patch-tools-debian.sh --install" >&2
  if [[ "$ALLOW_TSV_FALLBACK" -eq 1 ]]; then
    if [[ "$PROMPT_FOR_FALLBACK" -eq 1 && -t 0 ]]; then
      read -r -p "Use TSV fallback checklist for this run? [y/N] " answer
      case "$answer" in y|Y|yes|YES) CHECKLIST_FORMAT="tsv"; CHECKLIST="$TSV_CHECKLIST"; return 0 ;; esac
    elif [[ "$PROMPT_FOR_FALLBACK" -ne 1 ]]; then
      CHECKLIST_FORMAT="tsv"; CHECKLIST="$TSV_CHECKLIST"; return 0
    fi
  fi
  echo "error: cannot continue without YAML support or TSV fallback" >&2
  exit 1
}

require_git_repo() {
  if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
    echo "error: --apply/--check must run inside a git repository" >&2
    exit 1
  fi
}

require_clean_tree() {
  if [[ "$REQUIRE_CLEAN_TREE" -ne 1 ]]; then return 0; fi
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "error: working tree has uncommitted changes" >&2
    echo "commit or stash them before applying queued patches" >&2
    exit 1
  fi
}

init_dirs() {
  mkdir -p "$PENDING_DIR" "$APPLIED_DIR" "$FAILED_DIR"
  if [[ "$CHECKLIST_FORMAT" == "yaml" ]]; then
    [[ -f "$CHECKLIST" ]] || printf 'patches: []\n' > "$CHECKLIST"
  else
    [[ -f "$CHECKLIST" ]] || printf 'patch_id\tpatch_file\tstatus\tapplied_at\tsha256\tdescription\n' > "$CHECKLIST"
  fi
}

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  else echo "error: need sha256sum or shasum" >&2; exit 1; fi
}

patch_id_from_path() { basename "$1" | sed -E "s/^([0-9]{$ID_NUMBER_LENGTH}).*$/\1/"; }
patch_desc_from_path() { local stem; stem="$(basename "$1" .patch)"; echo "$stem" | sed -E "s/^[0-9]{$ID_NUMBER_LENGTH}-//; s/-/ /g"; }

is_applied_yaml() {
  local id="$1"
  python3 - "$CHECKLIST" "$id" <<'PY'
import sys, yaml
from pathlib import Path
path = Path(sys.argv[1]); pid = sys.argv[2]
if not path.exists(): raise SystemExit(1)
data = yaml.safe_load(path.read_text()) or {}
for row in data.get("patches", []):
    if str(row.get("id", "")) == pid and row.get("status") == "applied":
        raise SystemExit(0)
raise SystemExit(1)
PY
}

is_applied_tsv() { local id="$1"; [[ -f "$CHECKLIST" ]] && awk -F '\t' -v id="$id" 'NR>1 && $1==id && $3=="applied" { f=1 } END { exit f ? 0 : 1 }' "$CHECKLIST"; }
is_applied() { if [[ "$CHECKLIST_FORMAT" == "yaml" ]]; then is_applied_yaml "$1"; else is_applied_tsv "$1"; fi; }

upsert_checklist_entry_yaml() {
  python3 - "$CHECKLIST" "$1" "$2" "$3" "$4" "$5" "$6" <<'PY'
import sys, yaml
from pathlib import Path
path = Path(sys.argv[1])
entry = {"id": sys.argv[2], "file": sys.argv[3], "status": sys.argv[4], "applied_at": sys.argv[5], "sha256": sys.argv[6], "description": sys.argv[7]}
data = yaml.safe_load(path.read_text()) if path.exists() else None
if not isinstance(data, dict): data = {}
rows = data.get("patches") if isinstance(data.get("patches"), list) else []
rows = [r for r in rows if str(r.get("id", "")) != entry["id"]]
rows.append(entry); rows.sort(key=lambda r: str(r.get("id", "")))
data["patches"] = rows
path.write_text(yaml.safe_dump(data, sort_keys=False, allow_unicode=True))
PY
}

upsert_checklist_entry_tsv() {
  local id="$1" file="$2" status="$3" applied_at="$4" hash="$5" desc="$6" tmp
  tmp="$(mktemp)"
  awk -F '\t' -v OFS='\t' -v id="$id" 'NR==1 { print; next } $1!=id { print }' "$CHECKLIST" > "$tmp"
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$file" "$status" "$applied_at" "$hash" "$desc" >> "$tmp"
  mv "$tmp" "$CHECKLIST"
}

upsert_checklist_entry() { if [[ "$CHECKLIST_FORMAT" == "yaml" ]]; then upsert_checklist_entry_yaml "$@"; else upsert_checklist_entry_tsv "$@"; fi; }

add_patch_note() {
  local commit_sha="$1" id="$2" applied_path="$3" hash="$4" applied_at="$5" desc="$6"
  [[ "$CREATE_NOTES" -eq 1 ]] || return 0
  git notes --ref="$NOTES_REF" add -f -m "patch_id=$id
commit_sha=$commit_sha
patch_file=$applied_path
patch_sha256=$hash
applied_at=$applied_at
description=$desc" "$commit_sha" >/dev/null 2>&1 || echo "warning: failed to write git note for patch $id" >&2
}

push_notes_if_needed() {
  [[ "$CREATE_NOTES" -eq 1 && "$PUSH_NOTES" -eq 1 ]] || return 0
  if ! git remote get-url "$NOTES_REMOTE" >/dev/null 2>&1; then echo "warning: git notes were created locally, but remote '$NOTES_REMOTE' does not exist" >&2; return 0; fi
  echo "push: $NOTES_REF"
  git push "$NOTES_REMOTE" "$NOTES_REF" || { echo "warning: failed to push git notes" >&2; echo "hint: git push $NOTES_REMOTE $NOTES_REF" >&2; }
}

patch_glob() {
  printf '[0-9]%.0s' $(seq 1 "$ID_NUMBER_LENGTH")
  printf -- '-*.patch'
}

pending_patches() {
  local pattern
  pattern="$(patch_glob)"
  find "$PENDING_DIR" -maxdepth 1 -type f -name "$pattern" | sort
}

apply_one_patch() {
  local patch="$1" id desc hash applied_path applied_at commit_sha
  require_clean_tree
  id="$(patch_id_from_path "$patch")"; desc="$(patch_desc_from_path "$patch")"; hash="$(sha256_file "$patch")"
  applied_path="$APPLIED_DIR/$(basename "$patch")"
  if is_applied "$id"; then echo "skip: $id already marked applied"; return 0; fi
  echo "check: $patch"
  if ! git apply --check "$patch"; then
    mkdir -p "$FAILED_DIR"; mv "$patch" "$FAILED_DIR/$(basename "$patch")"
    upsert_checklist_entry "$id" "$FAILED_DIR/$(basename "$patch")" "failed" "" "$hash" "$desc"
    git add "$CHECKLIST" "$FAILED_DIR/$(basename "$patch")" || true
    git commit -m "Record failed patch $id" || true
    echo "error: patch failed check and was moved to $FAILED_DIR" >&2; exit 1
  fi
  echo "apply: $patch"; git apply "$patch"
  mkdir -p "$APPLIED_DIR"; mv "$patch" "$applied_path"
  applied_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  upsert_checklist_entry "$id" "$applied_path" "applied" "$applied_at" "$hash" "$desc"
  git add -A; git commit -m "Apply patch $id: $desc"
  commit_sha="$(git rev-parse HEAD)"
  add_patch_note "$commit_sha" "$id" "$applied_path" "$hash" "$applied_at" "$desc"
  echo "applied: $id -> $commit_sha"
}

main() {
  parse_args "$@"
  resolve_workspace
  load_config_if_present
  parse_args "$@"
  derive_paths_from_root
  validate_id_number_length

  if [[ "$GENERATE_CONFIG" -eq 1 ]]; then write_config; exit 0; fi

  require_git_repo
  choose_checklist_backend
  init_dirs
  echo "workspace: $(pwd)"
  echo "config: $CONFIG_FILE"
  echo "patch id pattern: [0-9]{$ID_NUMBER_LENGTH}-*.patch"
  echo "checklist: $CHECKLIST_FORMAT ($CHECKLIST)"

  mapfile -t patches < <(pending_patches)
  if [[ "${#patches[@]}" -eq 0 ]]; then echo "no pending patches"; exit 0; fi

  if [[ "$MODE" == "--check" ]]; then
    for patch in "${patches[@]}"; do
      id="$(patch_id_from_path "$patch")"
      if is_applied "$id"; then echo "skip: $id already marked applied"; continue; fi
      echo "check: $patch"; git apply --check "$patch"
    done
    echo "all pending patches check cleanly"; exit 0
  fi

  require_clean_tree
  for patch in "${patches[@]}"; do apply_one_patch "$patch"; done
  push_notes_if_needed
}

main "$@"
