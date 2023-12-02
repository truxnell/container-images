
FROM python:3.12-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

RUN apt-get update
RUN pip install --upgrade pip

ENV AUTHORIZATION_FAIL_MAX_RETRIES=3

RUN pip install b2==$VERSION

COPY apps/b2/entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

LABEL org.opencontainers.image.source="https://github.com/yt-dlp/yt-dlp"
