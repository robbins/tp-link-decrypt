#!/usr/bin/env bash
# Wrapper around the tp-link-decrypt container image.
# Uses stdin/stdout — no volume mounts needed.
#
# Usage: ./tp-link-decrypt.sh <firmware_file>
#
# The decrypted output is written to <firmware_file>.dec
# Status messages go to stderr.

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <firmware_file>" >&2
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: '$file': no such file" >&2
    exit 1
fi

out="${file}.dec"

docker run --rm -i tp-link-decrypt - < "$file" > "$out" || { rm -f "$out"; exit 1; }

echo "Decrypted firmware written to $out" >&2
