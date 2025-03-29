FROM python:3.13.2-bookworm

COPY --chmod=0755 entrypoint.sh /entrypoint.sh
COPY extract_dashboards.py extract_rules.py requirements.txt /app

WORKDIR /app

RUN echo "Intall convert requirements" && \
    pip3 install -r /app/requirements.txt

RUN mkdir /out
VOLUME /out

ENTRYPOINT /entrypoint.sh
