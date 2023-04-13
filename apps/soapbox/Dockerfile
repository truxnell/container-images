
FROM node:18-alpine@sha256:44aaf1ccc80eaed6572a0f2ef7d6b5a2982d54481e4255480041ac92221e2f11 as build

WORKDIR /app
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

RUN set -x \
  && curl -fsSL "https://gitlab.com/soapbox-pub/soapbox/-/archive/v${VERSION}/soapbox-v${VERSION}.tar.gz" | tar xzf - -C /app --strip-components=1 
RUN yarn 
ARG NODE_ENV=production
RUN yarn build

FROM nginxinc/nginx-unprivileged:1.23.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
EXPOSE 5000

COPY --from=build /app/static /usr/share/nginx/html

ENV PORT=5000
ENV FALLBACK_PORT=4444
ENV BACKEND_URL=http://localhost:4444
ENV CSP=
ENV NGINX_WEB_ROOT "/usr/share/nginx/html"

RUN \
    chown -R nginx:nginx "${NGINX_WEB_ROOT}" \
    && chmod -R 755 "${NGINX_WEB_ROOT}" 

USER nginx

WORKDIR ${NGINX_WEB_ROOT}

LABEL org.opencontainers.image.source="https://gitlab.com/soapbox-pub/soapbox"

