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
    apt-get clean && \
    rm -f /etc/ssh/ssh_host_*

COPY init.sh /init.sh

ENTRYPOINT ["/init.sh"]

CMD [ "/usr/sbin/sshd", "-D" ]