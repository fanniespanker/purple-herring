#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
usage: scripts/setup-patch-tools-debian.sh [--check|--install]

Installs or checks local dependencies for the Purple Herring patch queue tools on Debian/WSL.

Dependencies:
  - python3
  - python3-yaml

Modes:
  --check    verify dependencies only
  --install  install dependencies with apt, then verify
USAGE
}

MODE="${1:---check}"

case "$MODE" in
  --check|--install) ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

check_python_yaml() {
  python3 - <<'PY'
import sys
try:
    import yaml
except Exception as exc:
    print(f"error: Python 3 is available, but PyYAML import failed: {exc}", file=sys.stderr)
    raise SystemExit(1)
print("OK: python3 + PyYAML available")
PY
}

if [[ "$MODE" == "--install" ]]; then
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "error: apt-get not found; this setup script is intended for Debian/Ubuntu/WSL" >&2
    exit 1
  fi

  sudo apt-get update
  sudo apt-get install -y python3 python3-yaml
fi

check_python_yaml
