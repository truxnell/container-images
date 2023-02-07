
FROM ghcr.io/onedr0p/alpine:rolling@sha256:da2846e0398d55a5178448f7cb9ee1eeeeee13830fba40289152798595f78c8a

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

RUN set -x \
  && apk add --no-cache \
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

WORKDIR /downloads

VOLUME ["/downloads"]

USER kah

CMD ["/usr/local/bin/yt-dlp"]

LABEL org.opencontainers.image.source="https://github.com/yt-dlp/yt-dlp"
