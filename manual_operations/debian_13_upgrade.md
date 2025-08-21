# Debian Trixie (13) Upgrade

## Preparation

### Nginx nodes

Nginx had a few breaking changes.

```bash
# Nginx had a few breaking changes
# Avoid issue: "server_tokens" directive is duplicate in /etc/nginx/conf.d/security.conf:3
rm /etc/nginx/conf.d/security.conf

# Avoid issue: unknown directive "ssl" 
sed -i 's/ssl on;/#ssl on;/g' /etc/nginx/sites-available/*
```

## Upgrade

On each node :

```bash
rm /etc/apt/sources.list
rm /etc/apt/sources.list.d/debian.list

cat <<EOF > /etc/apt/sources.list.d/debian.sources
Types: deb deb-src
URIs: https://deb.debian.org/debian
Suites: trixie trixie-updates
Components: main contrib non-free non-free-firmware
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: https://security.debian.org/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

curl -fsSL https://packagecloud.io/crowdsec/crowdsec/gpgkey | gpg --dearmor > /etc/apt/keyrings/crowdsec_crowdsec-archive-keyring.gpg
cat <<EOF > /etc/apt/sources.list.d/crowdsec_crowdsec.list
deb [signed-by=/etc/apt/keyrings/crowdsec_crowdsec-archive-keyring.gpg] https://packagecloud.io/crowdsec/crowdsec/any any main
deb-src [signed-by=/etc/apt/keyrings/crowdsec_crowdsec-archive-keyring.gpg] https://packagecloud.io/crowdsec/crowdsec/any any main
EOF

apt-get update

apt-get -y upgrade --without-new-pkgs
apt-get -y full-upgrade
apt-get -y autoremove
```

The sysctl configs are disabled by the upgrade, restore them:

```bash
mv /etc/sysctl.conf.dpkg-bak /etc/sysctl.conf
```

Then reboot.

## Controller

```bash
rm -Rf /opt/ansible_venv
```

Reinstall ansible, and redeploy the playbook.
