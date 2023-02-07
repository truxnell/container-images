
FROM ghcr.io/onedr0p/alpine:rolling@sha256:e8ef8dfe8682db795944aeca61b456e684754e8ca0b78a29849adc1e9bad86bc

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

ENV PHANTOM_JS_VERSION ${PHANTOM_JS_VERSION:-2.1.1-linux-x86_64}
ARG PHANTOM_JS_VERSION

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
  # Insall phantomjs
  && mkdir /tmp/phantomjs \
  && curl -Ls http://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOM_JS_VERSION}.tar.bz2 \
         | tar -xj --strip-components=1 -C /tmp/phantomjs \
  && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
  && chmod a+rx /usr/local/bin/phantomjs \
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
    # Install official PhantomJS release


# ENV OPENSSL_CONF=/opt/openssl.cnf

# RUN set -x \
#   touch /opt/openssl.cnf 

WORKDIR /downloads

VOLUME ["/downloads"]

USER kah

CMD ["/usr/local/bin/yt-dlp"]

LABEL org.opencontainers.image.source="https://github.com/yt-dlp/yt-dlp"
