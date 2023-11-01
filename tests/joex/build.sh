#!/usr/bin/env bash
GIT_VERSION=$(curl -s https://api.github.com/repos/eikek/docspell/releases/latest | grep tag_name | cut -d '"' -f 4)
GIT_VERSION=${GIT_VERSION#v}
cp docker/dockerfiles/joex.dockerfile ./
mv joex.dockerfile Dockerfile
cp docker/dockerfiles/joex-entrypoint.sh ./
sed -i "s~ARG version=~ARG version=$GIT_VERSION~g" Dockerfile
sed -i "s~pip3 install --upgrade pip~pip3 install --upgrade pip --break-system-packages~g" Dockerfile
sed -i "s~pip3 install ocrmypdf~pip3 install ocrmypdf --break-system-packages~g" Dockerfile
docker buildx build . --output type=docker,name=elestio4test/docspell-joex:latest | docker load