FROM docker.io/library/debian:bullseye-20211201-slim

ENV DEBIAN_FRONTEND noninteractive
ENV DEBEMAIL Neraud

# Install Debian packaging tools

RUN apt-get update && \
    apt-get -y install packaging-dev debian-keyring devscripts equivs

RUN mkdir /work && \
    mkdir /out && \
    mkdir -p /opt/backports/packages.d

ENV WORK_DIR /work
ENV OUT_DIR /out
WORKDIR /work
VOLUME [ "/out" ]

ADD entrypoint.sh /root/entrypoint.sh
ADD backport.sh /opt/backports/
ENTRYPOINT /root/entrypoint.sh
