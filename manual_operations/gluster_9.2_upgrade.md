# Gluster 9.2 upgrade

## Preparation

### Stop workload

On each node :

```bash
systemctl stop kubelet
systemctl stop docker
```

### Stop volumes

On one node :

```bash
gluster volume list | while read vol ; do echo gluster volume stop $vol ; done
```

Execute all stop commands.

### Stop daemon

On all nodes :

```bash
systemctl stop glusterd
killall /usr/sbin/glusterfs
```

## Upgrade

On all nodes :

```bash
echo "deb https://download.gluster.org/pub/gluster/glusterfs/9/9.2/Debian/buster/amd64/apt buster main" > /etc/apt/sources.list.d/gluster.list
apt-get update
```

### Server nodes

```bash
apt-get -y remove glusterfs-server glusterfs-client
apt-get -y install glusterfs-server glusterfs-client
apt-get -y autoremove
```

### Client nodes

```bash
apt-get -y remove glusterfs-client
apt-get -y install glusterfs-client
apt-get -y autoremove
```

## Restart

### Start volumes

On one node :

```bash
gluster volume list | while read vol ; do gluster volume start $vol ; done
```

### Restart daemons

```bash
systemctl start docker
systemctl start kubelet
```

## Reboot

Finally `reboot` (if necessary ?)
