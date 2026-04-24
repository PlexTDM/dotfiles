#!/bin/bash

SAVE_DIR="$HOME/.cache/waifu_images"
mkdir -p "$SAVE_DIR"

echo "Downloading 100 images..."

RESPONSE=$(curl -s "https://api.waifu.im/images?is_nsfw=false&orientation=portrait&PageSize=100")

echo "$RESPONSE" | jq -c '.items[]' | while read -r item; do
    URL=$(echo "$item" | jq -r '.url')
    ID=$(echo "$item" | jq -r '.id')
    
    EXTENSION="${URL##*.}"
    FILE_PATH="$SAVE_DIR/$ID.${EXTENSION}"
    
    if [ ! -f "$FILE_PATH" ]; then
        curl -s "$URL" -o "$FILE_PATH" & 
    fi
done

wait
echo "Done! Images stored in $SAVE_DIR"