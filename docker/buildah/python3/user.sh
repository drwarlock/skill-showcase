#!/bin/bash
set -e
container=$1

buildah run "$container" addgroup --gid 1000 appuser
buildah run "$container" adduser --ingroup appuser appuser
build config -u 1000:1000 "$container"