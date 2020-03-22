FROM golang:1.12.5-alpine3.9

RUN apk add --no-cache git make g++

RUN echo "Install jsonnet" && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/google/jsonnet && \
    cd jsonnet && \
    make && \
    ln -s /opt/jsonnet/jsonnet /usr/local/bin/jsonnet

RUN echo "Install jsonnet-bundler" && \
    go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb

RUN mkdir /out
VOLUME /out

ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
