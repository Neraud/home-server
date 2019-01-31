FROM fluent/fluentd:v1.3.3-debian-1.0

USER root

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "3.1.0"]

RUN ["gem", "install", "fluent-plugin-ua-parser", "--no-rdoc", "--no-ri", "--version", "1.2.0"]
ADD --chown=fluent:fluent https://raw.githubusercontent.com/ua-parser/uap-core/v0.6.4/regexes.yaml /fluentd/ua-parser-regexes.yaml


USER fluent
