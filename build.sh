#!/usr/bin/env bash
set -eou pipefail

REPO="tomeinc/uncrustify"

# Build images
for f in images/*-Dockerfile; do
  docker build . -f "$f" -t "${REPO}:$(basename "$f" -Dockerfile)"
done
