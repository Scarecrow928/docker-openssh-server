FROM archlinux:latest

ENV PORT 2222
ENV PASSWORD_AUTHENTICATION no

RUN pacman -Syu --noconfirm --needed \
    openssh && \
    pacman -Scc --noconfirm

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]