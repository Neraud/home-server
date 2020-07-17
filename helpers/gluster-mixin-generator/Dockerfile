FROM golang:1.14.5-alpine3.12

RUN apk add --no-cache git

RUN echo "Install go-jsonnet" && \
    go get github.com/google/go-jsonnet/cmd/jsonnet

RUN echo "Install jsonnet-bundler" && \
    go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb

RUN mkdir /out
VOLUME /out

ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
