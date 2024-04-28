# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  echo "**** install runtime packages ****" && \
  apt update && \
  apt upgrade -y && \
  apt install -y \
    logrotate \
    nano \
    netcat-openbsd \
    sudo \
    openssh-server \
    openssh-client && \
  echo "**** setup openssh environment ****" && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
  usermod --shell /bin/bash abc && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

# add local files
COPY /root /

EXPOSE 2222

VOLUME /config
