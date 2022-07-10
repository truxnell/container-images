ARG ARCH="amd64"
ARG OS="linux"
FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest

ARG VERSION

ENV PATH="${PATH}:/sbin"

USER root

RUN mkdir /temp/ && \
  wget -q -O - "https://github.com/pdf/zfs_exporter/releases/download/v${VERSION}/zfs_exporter-${VERSION}.linux-amd64.tar.gz" | tar xzf - -C /temp/ --strip-components 1  && \
  cp /temp/zfs_exporter /bin/

USER nobody

LABEL \
  org.opencontainers.image.title="zfs_exporter" \
  org.opencontainers.image.source="https://github.com/pdf/zfs_exporter/" \
  org.opencontainers.image.version="${VERSION}"
EXPOSE 9134
ENTRYPOINT  [ "/bin/zfs_exporter" ]