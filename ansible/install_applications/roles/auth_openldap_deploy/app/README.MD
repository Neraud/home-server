# Source

Based on https://github.com/osixia/docker-openldap/tree/v1.2.3/example/kubernetes/using-secrets

# Limits

This container, at the moment, can't :
* be started as a regular user
* use a readonly root filesystem

## Root user only

root is required at least for the following :

* [debconf-set-selections](https://github.com/osixia/docker-openldap/blob/2a03b392b019adbf810f11bd64a2fed753d77b9d/image/service/slapd/startup.sh#L139)
* [dpkg-reconfigure](https://github.com/osixia/docker-openldap/blob/2a03b392b019adbf810f11bd64a2fed753d77b9d/image/service/slapd/startup.sh#L155)
* [slapd using <1000 ports](https://github.com/osixia/docker-openldap/blob/2a03b392b019adbf810f11bd64a2fed753d77b9d/image/service/slapd/process.sh#L12)

However, even using root, the `slapd` process properly runs as a non-privileged user : 

```shell
root@openldap-0:/# ps -eaf | grep slapd
openldap    78     1  0 09:34 ?        00:00:00 /usr/sbin/slapd -h ldap://openldap-0 ldaps://openldap-0 ldapi:/// -u openldap -g openldap -d 256
```

## Writable root filesystem

The root filesystem requires to be writable.

The first item that tries to write to the root filesystem is : 

* `/usr/sbin` is used to link tools (for example [ssl-tools](https://github.com/osixia/docker-light-baseimage/blob/807519dc9ec668f3df8ebe5d273e7f1ec4b9fa2b/image/service-available/:ssl-tools/startup.sh#L5))
