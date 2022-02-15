# Docker to CRI-O

See <https://github.com/cri-o/cri-o/blob/main/tutorials/kubernetes.md>

## Prepare FS

On each node :

```bash
lvcreate -L XXG -n lv_containers vg
mkfs.ext4 /dev/mapper/vg-lv_containers
mkdir -p /var/lib/containers
echo "/dev/vg/lv_containers /var/lib/containers ext4" >>/etc/fstab
mount /var/lib/containers
```

## Wipe docker

On each node :

```bash
systemctl stop kubelet
docker rm -f $(docker ps -aq)
apt-get purge docker-ce
apt-get autoremove --purge

rm -Rf /etc/systemd/system/docker.service.d
rm -Rf /etc/docker
rm /etc/cron.d/docker-gc
rm /etc/apt/sources.list.d/docker.list
rm -Rf /var/lib/docker/*

umount /var/lib/docker
sed -i '\|/var/lib/docker|d' /etc/fstab
lvremove -y /dev/mapper/vg-lv_docker

groupdel docker
```

## Re-deploy

Run the playbook :

- at least `Prepare Kubernetes members` from `install_infra` is needed to deploy CRI-O
- `install_applications` is needed to add missing caps

## Fix node annotation

```bash
kubectl annotate node [node-name] --overwrite kubeadm.alpha.kubernetes.io/cri-socket=/var/run/crio/crio.sock
```
