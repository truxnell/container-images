
FROM ghcr.io/onedr0p/alpine:rolling@sha256:51632d23e56ae28a34f8e90df6fe8d02730b5462697ae52e8b01ad6484497819

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}


RUN set -x \
  && apk add --no-cache \
  bzip2 \
  curl \
  ffmpeg \
  py3-pip \
  # Install youtube-dl
  && curl -Lo /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/download/${VERSION}/yt-dlp \
  #&& curl -Lo SHA2-256SUMS https://github.com/yt-dlp/yt-dlp/releases/download/${BUILD_VERSION}/SHA2-256SUMS \
  #&& cat SHA2-256SUMS | grep yt-dlp: | awk -F: '{print $2" "$1}' | sha256sum -c \
  && chmod a+rx /usr/local/bin/yt-dlp \
  # Clean-up
  #&& rm SHA2-256SUMS \ w
  && pip install mutagen \
  && apk del curl \
  # Create directory to hold downloads.
  && mkdir /downloads \
  && chmod a+rw /downloads \
  # Sets up cache.
  && mkdir /.cache \
  && chmod 777 /.cache

COPY ./apps/yt-dlp/wrapper.sh /wrapper.sh

WORKDIR /downloads

VOLUME ["/downloads"]

USER kah

CMD ["/wrapper.sh"]

LABEL org.opencontainers.image.source="https://github.com/yt-dlp/yt-dlp"
