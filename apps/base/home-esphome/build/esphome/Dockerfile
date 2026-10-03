FROM ghcr.io/esphome/esphome:2026.9.1

RUN echo "Create esp user" && \
    groupadd -g 1000 esp && \
    useradd -s /bin/sh -g esp -u 1000 --create-home esp

RUN echo "Copy platformio for esp" && \
    mv /root/.platformio /home/esp/ && \
    chown -R esp:esp /home/esp/.platformio

RUN echo "Chown piolibs for esp" && \
    chown -R esp:esp /piolibs

ENV PLATFORMIO_CORE_DIR=/tmp/.platformio

COPY entrypoint_custom.sh /
RUN chmod +x /entrypoint_custom.sh

USER esp

ENTRYPOINT [ "/entrypoint_custom.sh" ]
CMD ["dashboard", "/config"]
