#!/usr/bin/env bash
set -euo pipefail

# Antigravity CLI Installation Script
# Official source: https://antigravity.google
# 원격 스크립트를 파이프로 직접 실행하지 않고, 임시파일로 받아 sha256 표시 후 실행

REMOTE_URL="https://antigravity.google/cli/install.sh"

if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed." >&2
    exit 1
fi

TMP_SCRIPT="$(mktemp -t antigravity-install.XXXXXX)"
trap 'rm -f "$TMP_SCRIPT"' EXIT

echo "Downloading Antigravity installer from $REMOTE_URL ..."
# -f: HTTP 4xx/5xx에서 즉시 실패 (에러 본문이 bash로 흘러가지 않음)
# --proto '=https' --tlsv1.2: 다운그레이드 공격 차단
if ! curl -fsSL --proto '=https' --tlsv1.2 -o "$TMP_SCRIPT" "$REMOTE_URL"; then
    echo "Error: failed to download $REMOTE_URL" >&2
    exit 1
fi

if [ ! -s "$TMP_SCRIPT" ]; then
    echo "Error: downloaded installer is empty." >&2
    exit 1
fi

echo "Downloaded $(wc -c < "$TMP_SCRIPT") bytes."
if command -v shasum &> /dev/null; then
    echo "SHA256: $(shasum -a 256 "$TMP_SCRIPT" | awk '{print $1}')"
fi

echo "Executing installer..."
bash "$TMP_SCRIPT"

echo "Antigravity CLI installation initiated."
