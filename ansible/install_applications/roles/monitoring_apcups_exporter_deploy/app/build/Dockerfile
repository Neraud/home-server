
ARG from_image_build
ARG from_image

##############
# Build step #
##############

FROM $from_image_build AS build

ARG archive_url
ARG GO111MODULE=on
WORKDIR /go/src/

RUN apk add curl git --no-cache && \
    curl -o /tmp/apcupsd_exporter.tar.gz -L "$archive_url" && \
    mkdir -p /go/src/apcupsd_exporter && \
    cd /go/src/apcupsd_exporter && \
    tar xf /tmp/apcupsd_exporter.tar.gz --strip-components=1 && \
    go build -o /go/bin/apcupsd_exporter cmd/apcupsd_exporter/main.go



##############
# Image step #
##############

FROM $from_image

ENV APCUPS_ADDR ":3551"
ENV APCUPS_NETWORK "tcp"
ENV TELEMETRY_ADDR ":9162"
ENV TELEMETRY_PATH "/metrics"

COPY --from=build /go/bin/apcupsd_exporter /usr/local/bin/apcupsd_exporter

CMD /usr/local/bin/apcupsd_exporter \
    -apcupsd.addr $APCUPS_ADDR \
    -apcupsd.network $APCUPS_NETWORK \
    -telemetry.addr $TELEMETRY_ADDR \
    -telemetry.path $TELEMETRY_PATH
