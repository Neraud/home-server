# Sickchill fails to start with 3.12.0-slim-bookworm :ModuleNotFoundError: No module named 'pkg_resources'

FROM docker.io/library/python:3.11.6-slim-bookworm

RUN echo "Creating sickchill user" && \
    groupadd --gid 1000 sickchill && \
    useradd --create-home --gid sickchill --uid 1000 sickchill

RUN echo "Prepare folders" && \
    mkdir /data /app && \
    chown sickchill:sickchill /data /app

USER sickchill

RUN echo "Install sickchill" && \
    python3 -m venv /app/sickchill && \
    /app/sickchill/bin/pip3 install sickchill==2023.6.27

# Make sure cache is linked to the data dir : See https://github.com/SickChill/SickChill/issues/6010
#RUN ln -s /data/cache /app/sickchill/lib/python3.9/site-packages/sickchill/gui/slick/cache

ADD --chown=sickchill:sickchill inject_conf.py /app/inject_conf.py
ADD --chown=sickchill:sickchill entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

EXPOSE 8081

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f http://localhost:8081/ || curl -f https://localhost:8081/ || exit 1
