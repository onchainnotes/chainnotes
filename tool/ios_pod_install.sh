#!/usr/bin/env bash

#   ./tool/ios_pod_install.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/ios"
exec pod install "$@"
