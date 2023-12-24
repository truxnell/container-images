FROM ubuntu:22.04

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC"

# RUN \
#   apt-get update &&\
#   apt install -y --no-install-recommends gcc sox flac mp3val git wget curl python3 python3-pip &&\
#   git clone https://codeberg.org/xmoforf/smoked-salmon /app &&\
#   cd /app &&\
#   pip install --no-cache-dir -r requirements.txt 

RUN  apt-get update &&\
  apt-get install -y sox vi ffmpeg lame flac mp3val git wget curl python3 python3-pip &&\
  adduser kah \
  --uid 568 \
  --group \
  --system \
  --disabled-password \
  --no-create-home &&\
  git clone https://codeberg.org/xmoforf/smoked-salmon /app &&\
  cd /app &&\
  pip install --no-cache-dir  -r requirements.txt

#hadolint ignore=DL3018,DL3013
RUN \
  chown -R kah:kah /app &&\
  chmod -R 755 /app

USER kah

ENTRYPOINT ["python3", "/app/run.py"]
