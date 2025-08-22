FROM docker.io/library/node:23.10.0-alpine3.21 as builder

ARG reminiflux_repo=reminiflux/reminiflux
ARG reminiflux_commit=80815687c9d1f2883dc96f1d676eac399e276ddc

RUN mkdir /app
WORKDIR /app
RUN wget -q -O- https://github.com/${reminiflux_repo}/archive/${reminiflux_commit}.tar.gz  | tar xz --strip-components=1 -C /app
RUN npm install
# Build reminiflux with relative URLs
RUN NODE_OPTIONS=--openssl-legacy-provider PUBLIC_URL="." npm run build


FROM docker.io/library/nginx:1.27.4-alpine3.21-slim
COPY --from=builder /app/build /usr/share/nginx/html
ADD --chmod=755 50-custom-configure.sh /docker-entrypoint.d/50-custom-configure.sh

# Link writable folders under /tmp
RUN mkdir -p /tmp/cache/nginx && \
    rm -Rf /var/cache/nginx && \
    ln -s /tmp/cache/nginx /var/cache/nginx && \
    mkdir -p /tmp/run

# Configure writable folders under /tmp
RUN sed -i "s|/etc/nginx/conf.d|/tmp/nginx/conf.d|" /etc/nginx/nginx.conf && \
    sed -i "s|/var/run|/tmp/run|" /etc/nginx/nginx.conf && \
    sed -i "s|/usr/share/nginx/html|/tmp/nginx/html|" /etc/nginx/conf.d/default.conf && \
    sed -i 's/^user/#user/' /etc/nginx/nginx.conf
VOLUME [ "/tmp" ]

USER nginx
