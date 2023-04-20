
FROM node:20-alpine@sha256:2ffec31a58e85fbcd575c544a3584f6f4d128779e6b856153a04366b8dd01bb0 as build

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

