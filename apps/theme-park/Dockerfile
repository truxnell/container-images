FROM nginx:stable-alpine

ARG VERSION

USER root

RUN apk add --no-cache --virtual=build-dependencies python3 && \
curl -fsSL "https://github.com/GilbN/theme.park/archive/${VERSION}.tar.gz" | tar xzf - -C /tmp/ --strip-components 1  && \
python3 /tmp/themes.py && \
grep -rl 'https://theme-park.dev' /tmp | xargs sed -i 's/https\:\/\/theme-park.dev//g' && \
cp -r /tmp/css/ /usr/share/nginx/html/ && \
cp -r /tmp/resources/ /usr/share/nginx/html/ && \
cp /tmp/index.html /usr/share/nginx/html/ && \
rm -r tmp

LABEL \
  org.opencontainers.image.title="theme.park" \
  org.opencontainers.image.source="https://github.com/GilbN/theme.park" \
  org.opencontainers.image.version="${VERSION}"

