FROM ghcr.io/paperless-ngx/paperless-ngx:1.13.0

# if necessary, install lang packages (https://packages.debian.org/search?keywords=tesseract-ocr-)
#RUN apt-get update && \
#    apt-get install -y tesseract-ocr-eng && \
#    rm -rf /var/lib/apt/lists/*

# The rootless behaviour is to log/pid in PWD
# We force it to log/pid back in /var/log/supervisord
RUN sed -Ei 's,^(\s+)supervisord\.(log|pid),\1/var/log/supervisord/supervisord.\2,' /usr/local/bin/paperless_cmd.sh

# Link supervisord files under tmp
RUN rm -R /var/log/supervisord && \
    ln -s /tmp /var/log/supervisord && \
    rm -R /var/run/supervisord && \
    ln -s /tmp /var/run/supervisord

USER paperless
