ARG from_image
FROM $from_image

ARG fluent_plugin_elasticsearch_version
ARG fluent_plugin_ua_parser_version
ARG fluent_plugin_uap_core_version
ARG fluent_plugin_geoip_version

USER root

RUN fluent-gem install fluent-plugin-elasticsearch --no-document --version ${fluent_plugin_elasticsearch_version}

RUN fluent-gem install fluent-plugin-ua-parser --no-document --version ${fluent_plugin_ua_parser_version}
ADD --chown=fluent:fluent https://raw.githubusercontent.com/ua-parser/uap-core/v${fluent_plugin_uap_core_version}/regexes.yaml /fluentd/ua-parser-regexes.yaml

RUN apt-get update && apt-get install -y \
    build-essential \
    libgeoip-dev \
    libmaxminddb-dev \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/*
RUN fluent-gem install fluent-plugin-geoip --no-document --version ${fluent_plugin_geoip_version}

USER fluent
