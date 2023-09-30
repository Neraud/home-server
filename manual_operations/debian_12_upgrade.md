# Debian Bookworm (12) Upgrade

## Preparation

On each node :

```bash
cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian/ bookworm main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware

deb http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware
deb-src http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware

deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware
EOF

rm /etc/apt/sources.list.d/debian.list

apt-get update

apt-get -y upgrade --without-new-pkgs
apt-get -y full-upgrade
apt-get -y autoremove
```

There are changes in NGinx, modules that were installed by default don't seem to be there anymore.

Wipe NGinx and let the playbook redeploy it properly

```bash
apt-get -y purge nginx nginx-common libnginx-mod-http-geoip libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libnginx-mod-stream-geoip
rm -Rf /etc/nginx
```

## Controller

```bash
rm -Rf /opt/ansible_venv
```

Reinstall ansible, and redeploy the playbook.
