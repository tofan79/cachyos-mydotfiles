#!/usr/bin/env bash
set -Eeuo pipefail

DEPS=(grim slurp magick tesseract wl-copy timeout hyprpicker)
for dep in "${DEPS[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || { notify-send "Missing: $dep"; exit 1; }
done

hyprpicker -r -z &
PICKER_PID=$!
sleep 0.1

REGION=$(timeout 10 slurp -b "#00000080" -c "#888888ff" -w 1) || { notify-send "Text Extractor" "No region selected"; exit 1; }
kill "$PICKER_PID" 2>/dev/null || true

grim -g "$REGION" - \
  | magick - -colorspace Gray -normalize -contrast-stretch 2% -sharpen 0x1.0 -resize 200% png:- \
  | tesseract - stdout -l eng --psm 6 \
  | wl-copy \
  && notify-send "Text Extractor" "Text copied to clipboard" \
  || notify-send "Text Extractor" "Failed to extract text"
