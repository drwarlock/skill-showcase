#!/bin/bash
set -e

container=$(buildah from python:3.13.9-slim-bookworm)
buildah run --user 0:0 "$container" sh -c "sed -i 's/^Compents: main$/& bookworm contrib non-free/' /etc/apt/sources.list.d/debian.sources"
buildah run --user 0:0 "$container" sh -c "apt-get update"
buildah run --user 0:0 "$container" sh -c "apt-get install -y --no-install-recommends curl grep git bash make openssh-client libpam0g-dev passwrd login"

buildah copy --chown 0:0 "$container" install-poetry.py /tmp/install-poetry.py
buildah run --user 0:0 --env POETRY_HOME="/usr/bin/poetry" "$container" /bin/sh -c "python3 /tmp/install-poetry.py --version ${POETRY_VERSION}"
buildah config --env PATH=$PATH:/usr/bin/poetry/bin "$container"
buildah run --user 0:0 "$container" /bin/sh -c "poetry --version"

./user.sh "$container"
echo "container: $container"

buildah unmount "$container"
# conditional logic for branch release can go here
# if [ branch ] then
echo "Commit python3:${VERSION}"
buildah commit "$container" "python3:${VERSION}"
# else (not master commit a branch tag)
# fi