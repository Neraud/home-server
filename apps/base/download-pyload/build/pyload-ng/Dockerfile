FROM docker.io/library/python:3.11.2-slim-bullseye AS builder

# Install build requirements
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install --pre pyload-ng[plugins]==0.5.0b3.dev68


FROM docker.io/library/python:3.11.2-slim-bullseye

# Install requirements
# non-free is needed for unrar
#RUN sed -i "s|deb http://deb.debian.org/debian bullseye main|deb http://deb.debian.org/debian bullseye main non-free|g" /etc/apt/sources.list && \
#    apt-get update && \
#    apt-get install -y curl p7zip-full unrar unzip sqlite3 ffmpeg && \
#    rm -rf /var/lib/apt/lists/*

# Install requirements
RUN apt-get update && \
    apt-get install -y curl libcurl4 sqlite3 && \
    rm -rf /var/lib/apt/lists/*

# Create pyload user
RUN groupadd --gid 1000 pyload && \
    useradd --create-home --gid pyload --uid 1000 pyload

# Create pyload folders
RUN mkdir /config && \
    chown -R pyload:pyload /config && \
    mkdir /downloads && \
    chown -R pyload:pyload /downloads

ADD --chown=pyload:pyload entrypoint.sh /opt/entrypoint.sh
ADD --chown=pyload:pyload configure.py /opt/configure.py

USER pyload
WORKDIR /home/pyload

COPY --from=builder /opt/venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

ENV PYLOAD_DEBUG=0
ENV PYLOAD_CONF_webui_port=8000
ENV PYLOAD_CONF_webui_host=0.0.0.0
EXPOSE 8000

ENTRYPOINT [ "/opt/entrypoint.sh" ]
