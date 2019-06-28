FROM fluent/fluentd:v1.5.2-debian-1.0

USER root

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "3.4.3"]

RUN ["gem", "install", "fluent-plugin-ua-parser", "--no-document", "--version", "1.2.0"]
ADD --chown=fluent:fluent https://raw.githubusercontent.com/ua-parser/uap-core/v0.6.7/regexes.yaml /fluentd/ua-parser-regexes.yaml

RUN apt-get update && apt-get install -y \
    build-essential \
    libgeoip-dev \
    libmaxminddb-dev \
    ruby-dev \
 && rm -rf /var/lib/apt/lists/*
RUN ["gem", "install", "fluent-plugin-geoip", "--no-document", "--version", "1.3.1"]

USER fluent
