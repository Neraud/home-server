FROM fluent/fluentd:v1.3.3-debian-1.0

USER root

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "3.1.0"]

RUN ["gem", "install", "fluent-plugin-ua-parser", "--no-rdoc", "--no-ri", "--version", "1.2.0"]
ADD --chown=fluent:fluent https://raw.githubusercontent.com/ua-parser/uap-core/v0.6.4/regexes.yaml /fluentd/ua-parser-regexes.yaml

RUN apt-get update && apt-get install -y \
    build-essential \
    libgeoip-dev \
    libmaxminddb-dev \
    ruby-dev \
 && rm -rf /var/lib/apt/lists/*
RUN ["gem", "install", "fluent-plugin-geoip", "--no-rdoc", "--no-ri", "--version", "1.3.0"]

USER fluent
