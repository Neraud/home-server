ARG from_image
FROM $from_image

ARG homer_release

# Configure NGinx
ADD default.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080

# Use a dedicated volume for all run or tmp files
VOLUME [ "/tmp" ]
RUN mkdir -p /tmp/nginx && \
    mv /var/cache/nginx /tmp/nginx/cache && \
    ln -s /tmp/nginx/cache /var/cache/nginx && \
    mkdir -p /tmp/nginx/run/ && \
    sed -i -E 's|pid +/var/run/nginx.pid;|pid /tmp/nginx/run/nginx.pid;|' /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /tmp/nginx

# Install homer
RUN mkdir -p /opt/homer && \
    curl -Lq -o /tmp/homer.zip https://github.com/bastienwirtz/homer/releases/download/${homer_release}/homer.zip && \
    unzip /tmp/homer.zip -d /opt/homer && \
    rm /tmp/homer.zip && \
    rm -Rf /usr/share/nginx/html && \
    ln -s /opt/homer/ /usr/share/nginx/html

# Prepare downloaded asset folder
RUN mkdir -p /tmp/homer/downloaded_assets && \
    ln -s /tmp/homer/downloaded_assets /opt/homer/assets/download

ADD entrypoint.sh /opt/
RUN chown nginx:nginx /opt/entrypoint.sh && \
    chmod 744 /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

USER nginx
