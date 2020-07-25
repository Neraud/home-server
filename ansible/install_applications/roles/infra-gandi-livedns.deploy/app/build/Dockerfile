ARG from_image
FROM $from_image

ENV REFRESH_INTERVAL=600
ENV SET_IPV4="yes"
ENV TTL=300

RUN echo "Install requirements" && \
    apk add --no-cache bash curl jq

RUN echo "Creating gandi user" && \
    addgroup -g 1000 gandi && \
    adduser -u 1000 -G gandi -s /bin/sh -D gandi

RUN mkdir -p /opt/gandi-live-dns/
COPY run.sh update_ipv4.sh /opt/gandi-live-dns/
RUN chown -R gandi:gandi /opt/gandi-live-dns/ && \
    chmod +x /opt/gandi-live-dns/run.sh /opt/gandi-live-dns/update_ipv4.sh

USER gandi 
WORKDIR /opt/gandi-live-dns/

CMD ["./run.sh"]
