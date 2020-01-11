ARG from_image
FROM $from_image

USER root

RUN ["fluent-gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "3.8.0"]

RUN ["fluent-gem", "install", "fluent-plugin-ua-parser", "--no-document", "--version", "1.2.0"]
ADD --chown=fluent:fluent https://raw.githubusercontent.com/ua-parser/uap-core/v0.6.9/regexes.yaml /fluentd/ua-parser-regexes.yaml

RUN apt-get update && apt-get install -y \
    build-essential \
    libgeoip-dev \
    libmaxminddb-dev \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/*
RUN ["fluent-gem", "install", "fluent-plugin-geoip", "--no-document", "--version", "1.3.1"]

USER fluent
