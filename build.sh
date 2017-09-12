#!/bin/bash

DIST_DIR="/build/dist"

docker build --rm --tag=cryfs . --pull
rm -rf dist && mkdir -p dist
docker run --rm -v `pwd`/dist:"${DIST_DIR}" -e LOCAL_USER_ID=`id -u $USER` cryfs "/build/make.sh"
