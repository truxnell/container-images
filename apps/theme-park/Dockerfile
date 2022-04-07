FROM nginxinc/nginx-unprivileged

ARG VERSION

ENV PATH="${PATH}:/sbin"

USER root

RUN apt-get update && \
  apt-get -y install python3 && \
  curl -fsSL "https://github.com/GilbN/theme.park/archive/${VERSION}.tar.gz" | tar xzf - -C /tmp/ --strip-components 1  && \
  python3 /tmp/themes.py && \
  grep -rl 'https://theme-park.dev' /tmp | xargs sed -i 's/https\:\/\/theme-park.dev//g' && \
  cp -r /tmp/css/ /usr/share/nginx/html/ && \
  cp -r /tmp/resources/ /usr/share/nginx/html/ && \
  cp /tmp/index.html /usr/share/nginx/html/ && \
  rm -r tmp && \
  chown -R nginx:nginx /usr/share/nginx/html/

USER nginx

WORKDIR /usr/share/nginx/hmtl/

LABEL \
  org.opencontainers.image.title="theme.park" \
  org.opencontainers.image.source="https://github.com/GilbN/theme.park" \
  org.opencontainers.image.version="${VERSION}"

