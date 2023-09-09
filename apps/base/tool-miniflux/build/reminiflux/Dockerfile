FROM docker.io/library/node:20.6.0-alpine3.18 as builder

ARG reminiflux_repo=reminiflux/reminiflux
ARG reminiflux_commit=153dc9464cef69f7c29bff1d680cfa0013b5e281

RUN mkdir /app
WORKDIR /app
RUN wget -q -O- https://github.com/${reminiflux_repo}/archive/${reminiflux_commit}.tar.gz  | tar xz --strip-components=1 -C /app
RUN npm install
# Build reminiflux with relative URLs
RUN NODE_OPTIONS=--openssl-legacy-provider PUBLIC_URL="." npm run build


FROM docker.io/library/nginx:1.25.2-alpine3.18
COPY --from=builder /app/build /usr/share/nginx/html
ADD 50-custom-configure.sh /docker-entrypoint.d/50-custom-configure.sh

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
