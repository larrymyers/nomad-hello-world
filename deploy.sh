#!/usr/bin/env bash

if [[ -z "${NOMAD_ADDR}" ]]; then
   echo "NOMAD_ADDR environment variable is required"
   exit 1
fi

if [[ -z "${NOMAD_TOKEN}" ]]; then
   echo "NOMAD_TOKEN environment variable is required"
   exit 1
fi

VERSION=$(git rev-parse --short HEAD)

echo "VERSION=${VERSION}"

echo "Building docker image ..."

docker build -t docker.your-domain.tld/hello-world:"${VERSION}" .
docker push docker.your-domain.tld/hello-world:"${VERSION}"

echo "Deploying with nomad ..."

nomad job run -var="image_tag=${VERSION}" deploy.nomad
