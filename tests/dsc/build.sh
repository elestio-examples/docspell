#!/usr/bin/env bash
GIT_VERSION=$(curl -s https://api.github.com/repos/docspell/dsc/releases/latest | grep tag_name | cut -d '"' -f 4)
GIT_VERSION=${GIT_VERSION#v}
sed -i "s~ARG version=~ARG version=$GIT_VERSION~g" Dockerfile
docker buildx build . --output type=docker,name=elestio4test/docspell-dsc:latest | docker load