FROM nginxinc/nginx-unprivileged

ARG VERSION

ENV PATH="${PATH}:/sbin"

USER root

RUN apt-get update && \
  apt-get -y install python3 && \
  mkdir /temp && \
  curl -fsSL "https://github.com/GilbN/theme.park/archive/${VERSION}.tar.gz" | tar xzf - -C /temp/ --strip-components 1  && \
  python3 /temp/themes.py && \
  grep -rl 'https://theme-park.dev' /temp | xargs sed -i 's/https\:\/\/theme-park.dev//g' && \
  cp -r /temp/css/ /usr/share/nginx/html/ && \
  cp -r /temp/resources/ /usr/share/nginx/html/ && \
  cp /temp/index.html /usr/share/nginx/html/ && \
  rm -r temp && \
  chown -R nginx:nginx /usr/share/nginx/html/

USER nginx

WORKDIR /usr/share/nginx/hmtl/

LABEL \
  org.opencontainers.image.title="theme.park" \
  org.opencontainers.image.source="https://github.com/GilbN/theme.park" \
  org.opencontainers.image.version="${VERSION}"

