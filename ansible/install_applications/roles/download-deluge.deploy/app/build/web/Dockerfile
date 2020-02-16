ARG from_image
FROM $from_image

ENV DELUGE_LOGLEVEL=info

ADD --chown=deluge:deluge inject_web_config.py /opt/deluge/inject_web_config.py
ADD --chown=deluge:deluge entrypoint.sh /opt/deluge/entrypoint.sh
RUN chmod +x /opt/deluge/entrypoint.sh

ENTRYPOINT [ "/opt/deluge/entrypoint.sh" ]
