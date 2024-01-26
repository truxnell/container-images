FROM ghcr.io/onedr0p/ubuntu:jammy-20221101@sha256:bf2d52a2e698ab9c2e0a1af7f7b70b9806091c5ca21d9f1a4d1c3809f41e5e93 as build

ARG MIX_ENV=prod \
  OAUTH_CONSUMER_STRATEGIES="twitter facebook google microsoft slack github keycloak:ueberauth_keycloak_strategy"

WORKDIR /src

RUN apt-get update &&\
  apt-get install -y git elixir erlang-dev erlang-nox build-essential cmake libssl-dev libmagic-dev automake autoconf libncurses5-dev &&\
  mix local.hex --force &&\
  mix local.rebar --force

RUN git clone https://gitlab.com/soapbox-pub/rebased.git /src

RUN cd /src &&\
  mix deps.get --only prod &&\
  mkdir release &&\
  mix release --path release

FROM ghcr.io/onedr0p/ubuntu:jammy-20221101@sha256:bf2d52a2e698ab9c2e0a1af7f7b70b9806091c5ca21d9f1a4d1c3809f41e5e93

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC"


ARG HOME=/opt/pleroma
ARG DATA=/var/lib/pleroma

RUN apt-get update &&\
  apt-get install -y --no-install-recommends curl ca-certificates imagemagick libmagic-dev ffmpeg libimage-exiftool-perl libncurses5 postgresql-client fasttext &&\
  adduser --system --shell /bin/false --home ${HOME} pleroma &&\
  mkdir -p ${DATA}/uploads &&\
  mkdir -p ${DATA}/static &&\
  chown -R pleroma ${DATA} &&\
  mkdir -p /etc/pleroma &&\
  chown -R pleroma /etc/pleroma &&\
  mkdir -p /usr/share/fasttext &&\
  curl -L https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.ftz -o /usr/share/fasttext/lid.176.ftz &&\
  chmod 0644 /usr/share/fasttext/lid.176.ftz
RUN curl -L https://gitlab.com/soapbox-pub/rebased/-/raw/develop/config/docker.exs -o /etc/pleroma/config.exs &&\
  chmod 640 /etc/pleroma/config.exs &&\
  chown pleroma /etc/pleroma/config.exs

RUN curl -L https://gitlab.com/soapbox-pub/rebased/-/raw/develop/docker-entrypoint.sh -o /opt/pleroma/docker-entrypoint.sh &&\
  chmod +x /opt/pleroma/docker-entrypoint.sh

# Install soapbox
RUN wget https://gitlab.com/soapbox-pub/soapbox/-/jobs/artifacts/develop/download?job=build-production -O /tmp/soapbox.zip && \
  unzip /tmp/soapbox.zip -d /var/lib/pleroma/ && rm /tmp/soapbox.zip

USER pleroma

COPY --from=build --chown=pleroma:0 /src/release ${HOME}

ENTRYPOINT ["/opt/pleroma/docker-entrypoint.sh"]
