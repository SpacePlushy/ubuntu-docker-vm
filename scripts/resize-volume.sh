#!/bin/bash
NEW_SIZE=$1
if [ -z "$NEW_SIZE" ]; then
    echo "Usage: $0 <new-size-in-GB>"
    exit 1
fi

echo "Resizing volume to ${NEW_SIZE}GB..."
# Stop container
docker-compose down
# Resize sparse file
dd if=/dev/zero of=./storage.img bs=1 count=0 seek=${NEW_SIZE}G
# Resize filesystem
resize2fs ./storage.img
# Restart container
docker-compose up -d
echo "Resize complete"