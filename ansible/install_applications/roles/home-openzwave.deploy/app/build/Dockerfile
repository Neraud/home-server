ARG from_image
FROM $from_image

RUN apt-get update \
    && apt-get -y install socat \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN sed -i 's/:size=1024x768:/:size=1920x1080:/' /etc/services.d/ozwadmin/run
