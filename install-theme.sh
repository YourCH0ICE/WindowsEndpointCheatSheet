#!/usr/bin/env bash

set -e

THEME="$1"

if [ -z "$THEME" ]; then
    echo "Usage: ./install-theme.sh <theme-name>"
    exit 1
fi

echo "[+] Installing theme: $THEME"

PACKAGE="@quartz-themes/$THEME"

echo "[+] Installing npm package: $PACKAGE"
npm install "$PACKAGE"

echo "[+] Updating quartz.config.yaml..."

sed -i -E \
  's/(source: "@quartz-themes\/core")/\1/; /source: "@quartz-themes\/core"/,/mode:/ {
    /theme:/ s/theme: .*/theme: '"$THEME"'/
  }' quartz.config.yaml

echo "[+] Theme $THEME configured"
echo "[+] Starting Quartz..."

npx quartz build --serve