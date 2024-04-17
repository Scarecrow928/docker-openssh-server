FROM docker.io/library/debian:12

ENV PORT 2222
ENV PASSWORD_AUTHENTICATION no

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    openssh-client \
    ca-certificates \
    curl \
    vim && \
    apt-get clean

COPY init.sh /init.sh

ENTRYPOINT ["bash", "-c", "/init.sh"]