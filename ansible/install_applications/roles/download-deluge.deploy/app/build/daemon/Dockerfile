ARG from_image
FROM $from_image

ENV DELUGE_LOGLEVEL=info

ADD --chown=deluge:deluge inject_core_config.py /opt/deluge/inject_core_config.py
ADD --chown=deluge:deluge entrypoint.sh /opt/deluge/entrypoint.sh
RUN chmod +x /opt/deluge/entrypoint.sh

EXPOSE 58846 58946 58946/udp

ENTRYPOINT [ "/opt/deluge/entrypoint.sh" ]
