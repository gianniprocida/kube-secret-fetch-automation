#!/usr/bin/env bash
# Commands to run when the container starts.

# Copy our custom .bashrc from /etc into the home directory.
# This container will typically run in Kubernetes with a PVC mounted
# on the home directory. That means our ~/.bashrc would be hidden
# under the mount.
cp /etc/bashrc.local /home/axual/.bashrc

# This container is designed to run in Kubernetes, where it sleeps until it is needed.
exec sleep infinity
