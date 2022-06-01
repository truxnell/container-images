FROM erikvl87/languagetool

ARG VERSION

ENV PATH="${PATH}:/sbin"

USER root

RUN apk add --no-cache unzip && \
    mkdir -p /ngrams && \
    wget   -O /var/tmp/ngrams-en-20150817.zip && \
    unzip /var/tmp/ngrams-en-20150817.zip -d /ngrams && \
    rm /var/tmp/ngrams-en-20150817.zip && \
    apk del unzip

USER languagetool







