FROM fedora:26

ENV CRYFS_VERSION=0.9.7 \
    GOSU_GPG_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    GOSU_VERSION=1.10 \
    BUILD_DIR=/build \
    DIST_DIR=/build/dist

WORKDIR $BUILD_DIR

RUN dnf -y update \
  && dnf -y install \
    git \
    gcc-c++ \
    cmake \
    make \
    libcurl-devel \
    boost-devel \
    boost-static \
    cryptopp-devel \
    openssl-devel \
    fuse-devel \
    python \
    rpm-build \
    file \
    dpkg \
    gpg \
  && dnf clean all \
  && git config --global user.email "root@localhost" \
  && git config --global user.name "Root" \
  && mkdir -p ${DIST_DIR} \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${GOSU_GPG_KEY}" \
  && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc" \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && chmod 777 ${BUILD_DIR}

COPY scripts/make.sh make.sh
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x "${BUILD_DIR}/make.sh" \
  && chmod +x /usr/local/bin/entrypoint.sh

VOLUME "${DIST_DIR}"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["./make.sh"]
