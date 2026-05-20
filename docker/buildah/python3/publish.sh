#!/bin/bash
set -e

#conditional logic for branch tag and push can go here
# if [ branch ] then
SRC="python3:${VERSION}"
TARGET="${REGISTRY}/python3:${VERSION}"
echo "Tagging $SRC as $TARGET"
podman tag "$SRC" "$TARGET"
echo "Pushing $TARGET"
podman push "$TARGET"
echo "Published $TARGET"
# else (not master commit a branch tag)
# fi