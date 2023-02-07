
FROM ghcr.io/onedr0p/alpine:rolling@sha256:e8ef8dfe8682db795944aeca61b456e684754e8ca0b78a29849adc1e9bad86bc

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
