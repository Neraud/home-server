FROM golang:1.14.5-alpine3.12

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

RUN echo "Install gojsontoyaml" && \
    go get github.com/brancz/gojsontoyaml

RUN mkdir /out
VOLUME /out

ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
