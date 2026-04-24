#!/bin/bash

if ! command -v jq &> /dev/null || ! command -v bc &> /dev/null; then
    fastfetch > /dev/tty
    exit 0
fi

IMG_DIR="$HOME/.cache/waifu_images"
RANDOM_FILE=$(find "$IMG_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | shuf -n 1)

if [ -z "$RANDOM_FILE" ]; then
    fastfetch > /dev/tty
    exit 0
fi

# Use ImageMagick to get dimensions reliably regardless of filename
# [0] ensures we only get the first frame's dimensions for GIFs
DIMENSIONS=$(identify -format "%w %h" "$RANDOM_FILE[0]" 2>/dev/null)
ORIG_W=$(echo "$DIMENSIONS" | awk '{print $1}')
ORIG_H=$(echo "$DIMENSIONS" | awk '{print $2}')

# Fallback if identify fails
if [[ ! "$ORIG_W" =~ ^[0-9]+$ ]]; then
    TARGET_W=35
    TARGET_H=22
else
    TARGET_H=22
    # Calculate width with font correction
    TARGET_W=$(echo "($ORIG_W * $TARGET_H * 2.1) / $ORIG_H" | bc -l 2>/dev/null | cut -d'.' -f1)
fi

# Final sanity check for bc output
[[ -z "$TARGET_W" || "$TARGET_W" -le 0 ]] && TARGET_W=40

# Run it
fastfetch --logo "$RANDOM_FILE" --logo-type kitty-icat --processing-timeout 3000 > /dev/tty