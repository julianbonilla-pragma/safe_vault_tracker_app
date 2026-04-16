#!/usr/bin/env bash
set -euo pipefail

unset PUB_HOSTED_URL
unset FLUTTER_STORAGE_BASE_URL

exec flutter "$@"
