#!/bin/bash

set -e

mkdir -p /root/.ssh

echo "${INPUT_DEPLOYMENT_KEY}" | base64 -d >> "/root/.ssh/id_rsa" && \
    chmod 0700 "/root/.ssh" && \
    chmod 0600 "/root/.ssh/id_rsa"

cd "${PROJECT_DIR}" && rm -rf public/

export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
export GIT_SHA=$(git rev-parse --verify HEAD --short)

git submodule init && git submodule update --recursive

hugo

rsync -e 'ssh -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no' -avzhP "public/" "${INPUT_DEPLOYMENT_USER}"@"${INPUT_DESTINATION_HOST}":"${INPUT_DESTINATION_PATH}"
