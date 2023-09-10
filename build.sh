#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

IMAGE_NAME=harbor.mgmt.p.westeurope.azure.axual.cloud/axual/debug:0.1.1

podman manifest rm $IMAGE_NAME || true
podman build --platform linux/arm64/v8 --platform linux/amd64 --manifest "$IMAGE_NAME" .

# To push:
# podman manifest push $IMAGE_NAME docker://$IMAGE_NAME
