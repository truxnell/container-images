
FROM ghcr.io/onedr0p/alpine:rolling@sha256:51632d23e56ae28a34f8e90df6fe8d02730b5462697ae52e8b01ad6484497819

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}


RUN set -x \
  && apk add --no-cache \
  bzip2 \
  ffmpeg \
  py3-pip \
  && pip install -U pip setuptools wheel \
  && pip install --force-reinstall https://github.com/yt-dlp/yt-dlp/archive/master.tar.gz \
  && ln -s /usr/bin/yt-dlp /usr/local/bin/yt-dlp \
  #&& rm SHA2-256SUMS \ w
  && pip install mutagen \
  # Create directory to hold downloads.
  && mkdir /downloads \
  && chmod a+rw /downloads \
  # Sets up cache.
  && mkdir /.cache \
  && chmod 777 /.cache


# ENV OPENSSL_CONF=/opt/openssl.cnf

# RUN set -x \
#   touch /opt/openssl.cnf 

WORKDIR /downloads

VOLUME ["/downloads"]

USER kah

CMD ["/usr/local/bin/yt-dlp"]

LABEL org.opencontainers.image.source="https://github.com/yt-dlp/yt-dlp"
