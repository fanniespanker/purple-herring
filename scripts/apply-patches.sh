#!/usr/bin/env bash
set -euo pipefail

MODE="--check"
WORKDIR=""
CONFIG_FILE=""
GENERATE_CONFIG=0
FORCE_CONFIG=0
CREATE_NOTES=1
PUSH_NOTES=1
PATCH_ROOT="patches.d"
PENDING_DIR=""
APPLIED_DIR=""
FAILED_DIR=""
CHECKLIST=""
TSV_CHECKLIST=""
CHECKLIST_FORMAT="yaml"
FORCE_TSV=0
NOTES_REMOTE="origin"
NOTES_REF="refs/notes/commits"
ID_NUMBER_LENGTH=6
ALLOW_TSV_FALLBACK=1
PROMPT_FOR_FALLBACK=1
REQUIRE_CLEAN_TREE=1
PATCH_COUNT=""

CLI_PATCH_ROOT=0
CLI_PENDING_DIR=0
CLI_APPLIED_DIR=0
CLI_FAILED_DIR=0
CLI_CHECKLIST=0
CLI_TSV_CHECKLIST=0

usage() {
  cat <<'USAGE'
usage: scripts/apply-patches.sh [--check|--preview|--apply] [options]
       scripts/apply-patches.sh --generate-config [options]

Applies pending repository patches from the configured pending directory.

Workspace/config resolution:
  1. --working-dir DIR, if supplied
  2. current repository root, if run inside a git repo
  3. $HOME, if run outside a git repo

Default config path:
  .apply-patches.yaml, or .apply-patches if that file already exists

The config and YAML checklist use a restricted, schema-known YAML subset:
  - section mappings only
  - scalar values only
  - checklist patch records under patches: "NNNNNN":
  - no arrays, anchors, flow mappings, multiline scalars, or arbitrary YAML

Modes:
  --check             verify pending patches without applying them
  --preview, --what-if show patch order, applicability, stats, and summary without mutation
  --apply             apply pending patches, commit each patch, move it to applied/, update checklist
  --generate-config   write effective configuration and exit

Execution limit:
  --count N           process at most N pending patches in sorted order
  --one               alias for --count 1

Config/workspace:
  --working-dir DIR   use DIR as patch workspace
  --config FILE       read/write config file path
  --force             allow --generate-config to overwrite an existing config file

Directory/checklist options:
  --patch-root DIR        set patch queue root; implies conventional child paths unless overridden
  --pending-dir DIR       set pending patch directory
  --applied-dir DIR       set applied patch directory
  --failed-dir DIR        set failed patch directory
  --checklist FILE        set YAML checklist path
  --checklist-yaml FILE   alias for --checklist
  --checklist-tsv FILE    set TSV fallback checklist path
  --fallback-tsv          use TSV checklist instead of YAML
  --id-number-length N    set patch id digit count, default 6
  --id-width N            alias for --id-number-length

Git note options:
  --no-notes              do not create git notes for patch commits
  --no-push-notes         create local git notes, but do not push notes
  --notes-remote NAME     set notes remote, default origin
  --notes-ref REF         set notes ref, default refs/notes/commits
USAGE
}

die() { echo "error: $*" >&2; exit 1; }

parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --check|--apply) MODE="$1" ;;
      --preview|--what-if) MODE="--preview" ;;
      --generate-config|--generate-dot-file) GENERATE_CONFIG=1 ;;
      --working-dir) shift; [[ "$#" -gt 0 ]] || die "--working-dir requires a path"; WORKDIR="$1" ;;
      --config) shift; [[ "$#" -gt 0 ]] || die "--config requires a path"; CONFIG_FILE="$1" ;;
      --force) FORCE_CONFIG=1 ;;
      --fallback-tsv) FORCE_TSV=1; CHECKLIST_FORMAT="tsv" ;;
      --patch-root) shift; [[ "$#" -gt 0 ]] || die "--patch-root requires a directory"; PATCH_ROOT="$1"; CLI_PATCH_ROOT=1 ;;
      --count) shift; [[ "$#" -gt 0 ]] || die "--count requires a positive integer"; [[ "$1" =~ ^[1-9][0-9]*$ ]] || die "--count must be a positive integer, got: $1"; PATCH_COUNT="$1" ;;
      --one) PATCH_COUNT=1 ;;
      --pending-dir|--pending) shift; [[ "$#" -gt 0 ]] || die "--pending-dir requires a directory"; PENDING_DIR="$1"; CLI_PENDING_DIR=1 ;;
      --applied-dir|--applied) shift; [[ "$#" -gt 0 ]] || die "--applied-dir requires a directory"; APPLIED_DIR="$1"; CLI_APPLIED_DIR=1 ;;
      --failed-dir|--failed) shift; [[ "$#" -gt 0 ]] || die "--failed-dir requires a directory"; FAILED_DIR="$1"; CLI_FAILED_DIR=1 ;;
      --checklist|--checklist-yaml) shift; [[ "$#" -gt 0 ]] || die "--checklist requires a path"; CHECKLIST="$1"; CLI_CHECKLIST=1 ;;
      --checklist-tsv) shift; [[ "$#" -gt 0 ]] || die "--checklist-tsv requires a path"; TSV_CHECKLIST="$1"; CLI_TSV_CHECKLIST=1 ;;
      --id-number-length|--id-width) shift; [[ "$#" -gt 0 ]] || die "--id-number-length requires a number"; ID_NUMBER_LENGTH="$1" ;;
      --no-notes) CREATE_NOTES=0; PUSH_NOTES=0 ;;
      --no-push-notes) PUSH_NOTES=0 ;;
      --notes-remote) shift; [[ "$#" -gt 0 ]] || die "--notes-remote requires a remote name"; NOTES_REMOTE="$1" ;;
      --notes-ref) shift; [[ "$#" -gt 0 ]] || die "--notes-ref requires a ref"; NOTES_REF="$1" ;;
      -h|--help) usage; exit 0 ;;
      *) usage >&2; exit 2 ;;
    esac
    shift
  done
}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

yaml_unquote() {
  local s
  s="$(trim "$1")"
  case "$s" in
    \"*\")
      s="${s#\"}"; s="${s%\"}"
      s="${s//\\\"/\"}"
      s="${s//\\\\/\\}"
      ;;
    \'*\')
      s="${s#\'}"; s="${s%\'}"
      s="${s//\'\'/\'}"
      ;;
  esac
  printf '%s' "$s"
}

yaml_quote() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '"%s"' "$s"
}

bool_word() {
  case "$1" in
    1|true|True|TRUE|yes|Yes|YES) echo true ;;
    *) echo false ;;
  esac
}

bool_int() {
  case "$1" in
    1|true|True|TRUE|yes|Yes|YES) echo 1 ;;
    *) echo 0 ;;
  esac
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

  local section="" line raw key value
  while IFS= read -r raw || [[ -n "$raw" ]]; do
    line="$(trim "$raw")"
    [[ -z "$line" || "$line" == \#* ]] && continue

    if [[ "$raw" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*:[[:space:]]*$ ]]; then
      section="${BASH_REMATCH[1]}"
      case "$section" in patches|checklist|notes|git) ;; *) die "unsupported config section: $section" ;; esac
      continue
    fi

    if [[ "$raw" =~ ^[[:space:]]{2}([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*:[[:space:]]*(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="$(yaml_unquote "${BASH_REMATCH[2]}")"
      case "$section.$key" in
        patches.root) PATCH_ROOT="$value" ;;
        patches.pending_dir) PENDING_DIR="$value" ;;
        patches.applied_dir) APPLIED_DIR="$value" ;;
        patches.failed_dir) FAILED_DIR="$value" ;;
        patches.id_number_length|patches.id_width) ID_NUMBER_LENGTH="$value" ;;
        checklist.preferred_format) CHECKLIST_FORMAT="$value" ;;
        checklist.yaml_path|checklist.path) CHECKLIST="$value" ;;
        checklist.tsv_path) TSV_CHECKLIST="$value" ;;
        checklist.allow_tsv_fallback) ALLOW_TSV_FALLBACK="$(bool_int "$value")" ;;
        checklist.prompt_for_fallback) PROMPT_FOR_FALLBACK="$(bool_int "$value")" ;;
        notes.create) CREATE_NOTES="$(bool_int "$value")" ;;
        notes.push) PUSH_NOTES="$(bool_int "$value")" ;;
        notes.remote) NOTES_REMOTE="$value" ;;
        notes.ref) NOTES_REF="$value" ;;
        git.require_clean_tree) REQUIRE_CLEAN_TREE="$(bool_int "$value")" ;;
        *) die "unsupported config key: $section.$key" ;;
      esac
      continue
    fi

    die "unsupported config syntax: $raw"
  done < "$CONFIG_FILE"
}

derive_paths_from_root() {
  if [[ -z "$PENDING_DIR" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_PENDING_DIR" -eq 0 ) ]]; then PENDING_DIR="$PATCH_ROOT/pending"; fi
  if [[ -z "$APPLIED_DIR" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_APPLIED_DIR" -eq 0 ) ]]; then APPLIED_DIR="$PATCH_ROOT/applied"; fi
  if [[ -z "$FAILED_DIR" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_FAILED_DIR" -eq 0 ) ]]; then FAILED_DIR="$PATCH_ROOT/failed"; fi
  if [[ -z "$CHECKLIST" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_CHECKLIST" -eq 0 ) ]]; then CHECKLIST="$PATCH_ROOT/patches_checklist.yaml"; fi
  if [[ -z "$TSV_CHECKLIST" || ( "$CLI_PATCH_ROOT" -eq 1 && "$CLI_TSV_CHECKLIST" -eq 0 ) ]]; then TSV_CHECKLIST="$PATCH_ROOT/patches_checklist.tsv"; fi
  if [[ "$FORCE_TSV" -eq 1 ]]; then CHECKLIST_FORMAT="tsv"; fi
}

validate_config() {
  [[ "$ID_NUMBER_LENGTH" =~ ^[1-9][0-9]*$ ]] || die "id_number_length must be a positive integer, got: $ID_NUMBER_LENGTH"
  case "$CHECKLIST_FORMAT" in yaml|tsv) ;; *) die "checklist preferred_format must be yaml or tsv" ;; esac
}

write_config() {
  if [[ -e "$CONFIG_FILE" && "$FORCE_CONFIG" -ne 1 ]]; then
    die "config file already exists: $CONFIG_FILE (use --force to overwrite)"
  fi

  cat > "$CONFIG_FILE" <<YAML
patches:
  root: $(yaml_quote "$PATCH_ROOT")
  pending_dir: $(yaml_quote "$PENDING_DIR")
  applied_dir: $(yaml_quote "$APPLIED_DIR")
  failed_dir: $(yaml_quote "$FAILED_DIR")
  id_number_length: $ID_NUMBER_LENGTH

checklist:
  preferred_format: $(yaml_quote "$CHECKLIST_FORMAT")
  yaml_path: $(yaml_quote "$CHECKLIST")
  tsv_path: $(yaml_quote "$TSV_CHECKLIST")
  allow_tsv_fallback: $(bool_word "$ALLOW_TSV_FALLBACK")
  prompt_for_fallback: $(bool_word "$PROMPT_FOR_FALLBACK")

notes:
  create: $(bool_word "$CREATE_NOTES")
  push: $(bool_word "$PUSH_NOTES")
  remote: $(yaml_quote "$NOTES_REMOTE")
  ref: $(yaml_quote "$NOTES_REF")

git:
  require_clean_tree: $(bool_word "$REQUIRE_CLEAN_TREE")
YAML

  echo "wrote config: $(pwd)/$CONFIG_FILE"
}

require_git_repo() {
  git rev-parse --show-toplevel >/dev/null 2>&1 || die "--apply/--check/--preview must run inside a git repository"
}

require_clean_tree() {
  [[ "$REQUIRE_CLEAN_TREE" -eq 1 ]] || return 0
  if ! git diff --quiet || ! git diff --cached --quiet; then
    die "working tree has uncommitted changes; commit or stash them before applying queued patches"
  fi
}

init_dirs() {
  mkdir -p "$PENDING_DIR" "$APPLIED_DIR" "$FAILED_DIR"
  if [[ "$CHECKLIST_FORMAT" == "yaml" ]]; then
    [[ -f "$CHECKLIST" ]] || printf 'patches:\n' > "$CHECKLIST"
  else
    [[ -f "$TSV_CHECKLIST" ]] || printf 'patch_id\tpatch_file\tstatus\tapplied_at\tsha256\tdescription\n' > "$TSV_CHECKLIST"
  fi
}

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  else die "need sha256sum or shasum"; fi
}

patch_glob() {
  printf '[0-9]%.0s' $(seq 1 "$ID_NUMBER_LENGTH")
  printf -- '-*.patch'
}

patch_id_from_path() { basename "$1" | sed -E "s/^([0-9]{$ID_NUMBER_LENGTH}).*$/\1/"; }
patch_desc_from_path() { local stem; stem="$(basename "$1" .patch)"; echo "$stem" | sed -E "s/^[0-9]{$ID_NUMBER_LENGTH}-//; s/-/ /g"; }

pending_patches() {
  local pattern
  pattern="$(patch_glob)"
  find "$PENDING_DIR" -maxdepth 1 -type f -name "$pattern" | sort
}

limit_patches_by_count() {
  [[ -n "$PATCH_COUNT" ]] || return 0
  [[ "$PATCH_COUNT" =~ ^[1-9][0-9]*$ ]] || die "--count must be a positive integer, got: $PATCH_COUNT"
  if [[ "${#patches[@]}" -gt "$PATCH_COUNT" ]]; then
    patches=("${patches[@]:0:$PATCH_COUNT}")
  fi
}

is_applied_yaml() {
  local id="$1"
  awk -v id="$id" '
    $0 ~ "^[[:space:]]*\"?" id "\"?[[:space:]]*:[[:space:]]*$" { in_patch=1; next }
    in_patch && $0 ~ "^[[:space:]]{2}[^[:space:]]" { in_patch=0 }
    in_patch && $0 ~ "^[[:space:]]{4}status:[[:space:]]*\"?applied\"?[[:space:]]*$" { found=1 }
    END { exit found ? 0 : 1 }
  ' "$CHECKLIST"
}

is_applied_tsv() {
  local id="$1"
  [[ -f "$TSV_CHECKLIST" ]] && awk -F '\t' -v id="$id" 'NR>1 && $1==id && $3=="applied" { found=1 } END { exit found ? 0 : 1 }' "$TSV_CHECKLIST"
}

is_applied() {
  if [[ "$CHECKLIST_FORMAT" == "yaml" ]]; then is_applied_yaml "$1"; else is_applied_tsv "$1"; fi
}

write_checklist_yaml_from_tsv() {
  local tsv="$1" out="$2"
  {
    echo "patches:"
    sort -t $'\t' -k1,1 "$tsv" | while IFS=$'\t' read -r id patch_file status applied_at hash desc; do
      [[ -z "$id" || "$id" == "patch_id" ]] && continue
      echo "  $(yaml_quote "$id"):"
      echo "    patch_file: $(yaml_quote "$patch_file")"
      echo "    status: $(yaml_quote "$status")"
      echo "    applied_at: $(yaml_quote "$applied_at")"
      echo "    sha256: $(yaml_quote "$hash")"
      echo "    description: $(yaml_quote "$desc")"
    done
  } > "$out"
}

checklist_yaml_to_tsv() {
  local yaml="$1" tsv="$2"
  awk '
    function trim(s){ sub(/^[[:space:]]+/,"",s); sub(/[[:space:]]+$/,"",s); return s }
    function unq(s){ s=trim(s); if (s ~ /^".*"$/){ sub(/^"/,"",s); sub(/"$/,"",s); gsub(/\\"/,"\"",s); gsub(/\\\\/,"\\",s) } return s }
    BEGIN { OFS="\t"; print "patch_id","patch_file","status","applied_at","sha256","description" }
    /^[[:space:]]{2}"?[0-9]+"?:[[:space:]]*$/ {
      if (id != "") print id, file, status, at, hash, desc
      line=$0; gsub(/^[[:space:]]+/,"",line); sub(/:.*/,"",line); gsub(/"/,"",line)
      id=line; file=status=at=hash=desc=""; next
    }
    id != "" && /^[[:space:]]{4}[A-Za-z_][A-Za-z0-9_]*:[[:space:]]*/ {
      line=$0; sub(/^[[:space:]]+/,"",line); key=line; sub(/:.*/,"",key); val=line; sub(/^[^:]*:[[:space:]]*/,"",val); val=unq(val)
      if (key=="patch_file" || key=="file") file=val
      else if (key=="status") status=val
      else if (key=="applied_at") at=val
      else if (key=="sha256") hash=val
      else if (key=="description") desc=val
      next
    }
    END { if (id != "") print id, file, status, at, hash, desc }
  ' "$yaml" > "$tsv"
}

upsert_checklist_entry_tsv_file() {
  local tsv="$1" id="$2" patch_file="$3" status="$4" applied_at="$5" hash="$6" desc="$7" tmp
  tmp="$(mktemp)"
  if [[ -f "$tsv" ]]; then awk -F '\t' -v OFS='\t' -v id="$id" 'NR==1 { print; next } $1!=id { print }' "$tsv" > "$tmp"; else printf 'patch_id\tpatch_file\tstatus\tapplied_at\tsha256\tdescription\n' > "$tmp"; fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$patch_file" "$status" "$applied_at" "$hash" "$desc" >> "$tmp"
  mv "$tmp" "$tsv"
}

upsert_checklist_entry() {
  local id="$1" patch_file="$2" status="$3" applied_at="$4" hash="$5" desc="$6" tmp
  if [[ "$CHECKLIST_FORMAT" == "tsv" ]]; then
    upsert_checklist_entry_tsv_file "$TSV_CHECKLIST" "$id" "$patch_file" "$status" "$applied_at" "$hash" "$desc"
    return 0
  fi
  tmp="$(mktemp)"
  checklist_yaml_to_tsv "$CHECKLIST" "$tmp"
  upsert_checklist_entry_tsv_file "$tmp" "$id" "$patch_file" "$status" "$applied_at" "$hash" "$desc"
  write_checklist_yaml_from_tsv "$tmp" "$CHECKLIST"
  rm -f "$tmp"
}

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

preview_one_patch() {
  local patch="$1" id desc hash
  id="$(patch_id_from_path "$patch")"; desc="$(patch_desc_from_path "$patch")"; hash="$(sha256_file "$patch")"
  echo
  echo "preview: $patch"
  echo "patch_id: $id"
  echo "description: $desc"
  echo "sha256: $hash"
  if is_applied "$id"; then echo "status: already marked applied"; else echo "status: pending"; fi
  if git apply --check "$patch"; then echo "check: ok"; else echo "check: failed"; return 1; fi
  echo "stat:"
  git apply --stat "$patch"
  echo "summary:"
  git apply --summary "$patch"
}

apply_one_patch() {
  local patch="$1" id desc hash applied_path applied_at commit_sha
  require_clean_tree
  id="$(patch_id_from_path "$patch")"; desc="$(patch_desc_from_path "$patch")"; hash="$(sha256_file "$patch")"
  applied_path="$APPLIED_DIR/$(basename "$patch")"
  if is_applied "$id"; then echo "skip: $id already marked applied"; return 0; fi
  echo "check: $patch"
  if ! git apply --check "$patch"; then
    die "patch failed check: $patch"
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
  validate_config

  if [[ "$GENERATE_CONFIG" -eq 1 ]]; then write_config; exit 0; fi

  require_git_repo
  init_dirs
  echo "workspace: $(pwd)"
  echo "config: $CONFIG_FILE"
  echo "patch id pattern: [0-9]{$ID_NUMBER_LENGTH}-*.patch"
  if [[ "$CHECKLIST_FORMAT" == "yaml" ]]; then echo "checklist: yaml ($CHECKLIST)"; else echo "checklist: tsv ($TSV_CHECKLIST)"; fi

  mapfile -t patches < <(pending_patches)
  limit_patches_by_count
  if [[ "${#patches[@]}" -eq 0 ]]; then echo "no pending patches"; exit 0; fi

  if [[ "$MODE" == "--preview" ]]; then
    failures=0
    for patch in "${patches[@]}"; do preview_one_patch "$patch" || failures=1; done
    [[ "$failures" -eq 0 ]] || die "one or more pending patches failed preview checks"
    echo "preview complete"
    exit 0
  fi

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
