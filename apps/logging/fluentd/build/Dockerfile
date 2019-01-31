FROM fluent/fluentd:v1.3.3-debian-1.0

USER root

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "3.1.0"]

USER fluent
