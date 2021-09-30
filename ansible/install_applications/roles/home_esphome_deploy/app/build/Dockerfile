ARG from_image
FROM $from_image

RUN echo "Create esp user" && \
    groupadd -g 1000 esp && \
    useradd -s /bin/sh -g esp -u 1000 --create-home esp

RUN echo "Copy platformio for esp" && \
    mv /root/.platformio /home/esp/ && \
    chown -R esp:esp /home/esp/.platformio

ENV PLATFORMIO_CORE_DIR=/tmp/.platformio

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER esp

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["dashboard", "/config"]
