#!/bin/bash

set -euxo pipefail

git clone --branch "${CRYFS_VERSION}" https://github.com/cryfs/cryfs.git cryfs \
  && cd cryfs \
  && git cherry-pick f1c6fa044f44e33c0c9e6eab78877d47ac4c87be \
  && mkdir -p cmake \
  && cd cmake \
  && cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=off \
  && make package \
  && mkdir -p ../../dist \
  && mv cryfs-${CRYFS_VERSION}+*.{deb,rpm,tar.gz} "${DIST_DIR}"
