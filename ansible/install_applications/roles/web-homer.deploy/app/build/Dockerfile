ARG from_image
FROM $from_image

ARG homer_commit

# Configure NGinx
ADD default.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080

# Use a dedicated volume for all run or tmp files
VOLUME [ "/tmp" ]
#/ # grep pid /etc/nginx/nginx.conf 
#pid        /var/run/nginx.pid;

# Install homer
RUN mkdir -p /opt/homer && \
    cd /opt/homer && \
    wget -qO- https://github.com/bastienwirtz/homer/archive/${homer_commit}.tar.gz | tar xz --strip-components=1 && \
    rm -Rf /usr/share/nginx/html && \
    ln -s /opt/homer /usr/share/nginx/html

ADD entrypoint.sh /opt/
RUN chown nginx:nginx /opt/entrypoint.sh && \
    chmod 744 /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

#USER nginx
