FROM ghcr.io/esphome/esphome:2024.2.2

RUN echo "Create esp user" && \
    groupadd -g 1000 esp && \
    useradd -s /bin/sh -g esp -u 1000 --create-home esp

RUN echo "Copy platformio for esp" && \
    mv /root/.platformio /home/esp/ && \
    chown -R esp:esp /home/esp/.platformio

RUN echo "Chown piolibs for esp" && \
    chown -R esp:esp /piolibs

ENV PLATFORMIO_CORE_DIR=/tmp/.platformio

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER esp

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["dashboard", "/config"]
