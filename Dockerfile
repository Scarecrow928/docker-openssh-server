FROM archlinux:latest

ENV PORT 2222
ENV PASSWORD_AUTHENTICATION no

RUN pacman -Syu --noconfirm --needed \
    openssh && \
    pacman -Scc --noconfirm

COPY init.sh /init.sh

ENTRYPOINT ["bash", "-c", "/init.sh"]