FROM docker.io/fluent/fluentd:v1.16.2-debian-amd64-1.0

USER root

RUN fluent-gem install fluent-plugin-opensearch --no-document --version 1.1.4

RUN fluent-gem install fluent-plugin-prometheus --no-document --version 2.1.0

RUN fluent-gem install fluent-plugin-ua-parser --no-document --version 1.2.0
ADD --chown=fluent:fluent https://raw.githubusercontent.com/ua-parser/uap-core/v0.18.0/regexes.yaml /fluentd/ua-parser-regexes.yaml

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    libgeoip-dev \
    libmaxminddb-dev \
    libtool \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/*
RUN fluent-gem install fluent-plugin-geoip --no-document --version 1.3.2

USER fluent
