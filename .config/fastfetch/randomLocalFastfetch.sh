#!/bin/bash

if ! command -v jq &> /dev/null || ! command -v bc &> /dev/null; then
    fastfetch
    exit 1
fi

API_URL="https://api.waifu.im/images?is_nsfw=false&orientation=portrait&page_size=1"
RESPONSE=$(curl -s "$API_URL")

# Parsing using .items as per your provided schema
IMAGE_URL=$(echo "$RESPONSE" | jq -r '.items[0].url')
ORIG_W=$(echo "$RESPONSE" | jq -r '.items[0].width')
ORIG_H=$(echo "$RESPONSE" | jq -r '.items[0].height')

if [ -z "$IMAGE_URL" ] || [ "$IMAGE_URL" == "null" ]; then
    fastfetch
    exit 1
fi

TEMP_IMG="/tmp/waifu_fetch_image"
curl -s "$IMAGE_URL" -o "$TEMP_IMG"

TARGET_H=24
# Calculation using 2.1 font aspect ratio correction
TARGET_W=$(echo "($ORIG_W * $TARGET_H * 2.1) / $ORIG_H" | bc -l | cut -d'.' -f1)

if [ -z "$TARGET_W" ] || [ "$TARGET_W" -eq 0 ]; then
    TARGET_W=40
fi

# Mandatory --logo-type kitty to force image rendering
fastfetch --logo "$TEMP_IMG" --logo-width "$TARGET_W" --logo-height "$TARGET_H"