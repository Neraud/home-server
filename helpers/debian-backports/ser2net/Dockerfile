FROM debian-backports-base:bullseye

# gensio dependencies
RUN apt-get -y install debhelper-compat dh-python swig python3-dev pkg-config libssl-dev libwrap0-dev libopenipmi-dev libpam-dev libsctp-dev libavahi-client-dev

# ser2net dependencies (without gensio)
RUN apt-get -y install debhelper-compat libavahi-client-dev libopenipmi-dev libsctp-dev libwrap0-dev libyaml-dev pkg-config
# Without packages from gensio : libgensio-dev python3-gensio

ADD 1-gensio.sh /opt/backports/packages.d/
ADD 2-ser2net.sh /opt/backports/packages.d/
