# Debian Bullseye (11) Upgrade

## Preparation

On each node :

```bash
cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian/ bullseye main
deb-src http://deb.debian.org/debian/ bullseye main

deb http://security.debian.org/debian-security bullseye-security main
deb-src http://security.debian.org/debian-security bullseye-security main
EOF

rm /etc/apt/sources.list.d/debian.list
rm /etc/apt/sources.list.d/gluster.list

apt update

systemctl stop kubelet
systemctl stop docker
systemctl stop glusterd

killall /usr/sbin/glusterfs


apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
```

## Updated configurations

Some configurations have changed in upgraded packages.

* /etc/haproxy/haproxy.cfg
* /etc/default/dnsmasq
* /etc/sysctl.conf
* /etc/avahi/avahi-daemon.conf
* /etc/ssh/sshd_config

```bash
sed -i 's/cgroupDriver: cgroupfs/cgroupDriver: systemd/g' /var/lib/kubelet/config.yaml

mv /etc/ssh/sshd_config.ucf-dist /etc/ssh/sshd_config

mv /etc/avahi/avahi-daemon.conf.dpkg-dist /etc/avahi/avahi-daemon.conf
sed -i 's/#enable-reflector=no/enable-reflector=yes/' /etc/avahi/avahi-daemon.conf

update-alternatives --install /usr/bin/python python /usr/bin/python3 2
```

## Reboot

Finally, `reboot`.

## Controller

Reinstall ansible.
