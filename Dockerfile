FROM docker.io/library/debian:stable

ARG DEBIAN_FRONTEND=noninteractive

COPY init.sh /init.sh

RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    tzdata \
    vim \
    curl \
    wget \
    net-tools \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /init.sh

VOLUME [ "/etc/ssh" ]

CMD ["/init.sh"]