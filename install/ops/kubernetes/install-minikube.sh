#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.21.0
readonly STUFF=minikube-linux-amd64

wget --quiet --output-document=$HOME/bin/minikube https://github.com/kubernetes/minikube/releases/download/v$VERSION/$STUFF
chmod +x $HOME/bin/minikube
