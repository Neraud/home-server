ARG from_image
FROM $from_image

# pre-optimize to avoid a horribly long first run
RUN /usr/local/bin/kibana-docker --optimize
