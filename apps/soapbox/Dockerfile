
FROM node:18-alpine@sha256:f27e3f4c8b5719cb9816084475d687a283c59149f3d11a7aa45b675fea56bed0 as build

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

FROM nginxinc/nginx-unprivileged:1.23.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
EXPOSE 5000

ENV PORT=5000
ENV FALLBACK_PORT=4444
ENV BACKEND_URL=http://localhost:4444
ENV CSP=

COPY --from=build /app/static /usr/share/nginx/html

ENV NGINX_WEB_ROOT "/usr/share/nginx/html"
RUN  \
    && chown -R nginx:nginx "${NGINX_WEB_ROOT}" \
    && chmod -R 755 "${NGINX_WEB_ROOT}" \

USER nginx

WORKDIR ${NGINX_WEB_ROOT}

LABEL org.opencontainers.image.source="https://github.com/GilbN/theme.park"

