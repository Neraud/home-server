FROM docker.io/library/golang:1.19.2-alpine3.16

RUN apk add --no-cache git

RUN echo "Install go-jsonnet" && \
    go install github.com/google/go-jsonnet/cmd/jsonnet@latest

RUN echo "Install jsonnet-bundler" && \
    go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest

RUN echo "Install gojsontoyaml" && \
    go install github.com/brancz/gojsontoyaml@latest

RUN mkdir /out
VOLUME /out

ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
