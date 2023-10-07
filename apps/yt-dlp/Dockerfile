
FROM ghcr.io/onedr0p/alpine:rolling@sha256:def056ca431d37935788aade44889bd34ca0f6b00bffff49dad41a613c0f79c7

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
