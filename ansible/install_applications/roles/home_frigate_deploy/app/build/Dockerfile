ARG from_image
FROM $from_image

# Use a dedicated volume for all run or tmp files
VOLUME [ "/tmp" ]
RUN mkdir -p /tmp/run && \
    rm -Rf /var/run && \
    ln -s /tmp/run /var/run && \
    mkdir -p /tmp/nginx/log && \
    rm -Rf /var/log/nginx && \
    ln -s /tmp/nginx/log /var/log/nginx && \
    mkdir -p /tmp/nginx/lib && \
    rm -Rf /var/lib/nginx && \
    ln -s /tmp/nginx/lib /var/lib/nginx

# To avoid the warning :
# Matplotlib created a temporary config/cache directory at /tmp/matplotlib-b7qmf_it because the default path (/root/.config/matplotlib) is not a writable directory; it is highly recommended to set the MPLCONFIGDIR environment variable to a writable directory, in particular to speed up the import of Matplotlib and to better support multiprocessing.
ENV MPLCONFIGDIR=/tmp/matplotlib
RUN mkdir -p $MPLCONFIGDIR

ADD entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
