#!/usr/bin/env bash

mode=$1

if [ "$mode" != "controller" ]; then
	mode="node"
fi

echo ""
echo "=================================================="
echo "Updating package list and distribution"
echo "=================================================="

export DEBIAN_FRONTEND=noninteractive

echo " - fix grub config"
# In the base image, grub is installed on /dev/vda (see : debconf-show grub-pc | grep install_devices)
# When upgrading grub2 in interactive mode, it prompts to select a new disk. Selecting /dev/sda works.
# When upgrading grub2 in non interactive mode, grub2 will be left in a broken state, and the VM won't reboot.
# (error: symbol `grub_calloc' not found.)
echo "grub-pc grub-pc/install_devices multiselect /dev/sda" | debconf-set-selections

echo " - update"
apt-get -y update

echo " - upgrade"
apt-get -q -y upgrade

echo " - install python3"
apt-get -q -y install python3
update-alternatives --install /usr/bin/python python /usr/bin/python3 2

mkdir -p /root/.ssh

echo " - add ansible key to authorized keys"
touch /root/.ssh/authorized_keys
searchLocalKey=$(grep -c "$(cat /vagrant/ssh/id_rsa.pub)" /root/.ssh/authorized_keys)
if [ $searchLocalKey -eq 0 ]; then
	cat /vagrant/ssh/id_rsa.pub >>/root/.ssh/authorized_keys
fi

chmod -R 700 /root/.ssh

echo " - install LVM"
apt-get -q -y install lvm2

if [ -e /dev/sdb ]; then
	echo " - preparing docker disk"
	# Create a new partition table with a single LVM partition
	echo 'type=8e' | sfdisk /dev/sdb
	pvcreate /dev/sdb1
	vgcreate vg /dev/sdb1

	lvcreate -L 1G -n lv_kubelet vg
	mkfs.ext4 /dev/mapper/vg-lv_kubelet
	mkdir -p /var/lib/kubelet

	lvcreate -l 100%FREE -n lv_containers vg
	mkfs.ext4 /dev/mapper/vg-lv_containers
	mkdir -p /var/lib/containers

	echo "/dev/vg/lv_containers /var/lib/containers ext4" >>/etc/fstab
	echo "/dev/vg/lv_kubelet /var/lib/kubelet ext4" >>/etc/fstab

	mount -a
fi

if [ -e /dev/sdc ]; then
	echo " - preparing data disk for LVM"
	# Create a new partition table with a single LVM partition
	echo 'type=8e' | sfdisk /dev/sdc
	pvcreate /dev/sdc1
	vgcreate data_vg /dev/sdc1
fi

## see https://github.com/ansible/ansible/issues/45446#issuecomment-467829815
## But the proposed workaround doesn't work if we simply add it in the ansible playbook
echo " - install and enable ufw (workaround to avoid hanging)"
update-alternatives --set iptables /usr/sbin/iptables-legacy
apt-get -q -y install ufw
ufw allow OpenSSH
yes | sudo ufw enable

if [ "$mode" == "controller" ]; then
	echo " - install ansible controller"
	bash /opt/provision/install_controller_requirements.sh
	source /opt/ansible_venv/bin/activate

	echo " - install ansible ssh keys"
	cp -R /vagrant/ssh/* /root/.ssh/
	chmod -R 700 /root/.ssh

	echo " - add hosts to known hosts"
	touch /root/.ssh/known_hosts
	host_ips=$(
		python - <<'__EOF__'
import yaml
config = yaml.load(open("/opt/provision/vagrant/Vagrantconfig.yaml", "r"), yaml.SafeLoader)
print(config['controller']['ip'])
for node_conf in config['nodes']:
  print(node_conf['ip'])
__EOF__
	)
	for host_ip in $host_ips localhost; do
		echo "    * "$host_ip
		knownKey=$(ssh-keygen -F $host_ip)
		if [ "$knownKey" == "" ]; then
			ssh-keyscan -H -T 10 $host_ip >>/root/.ssh/known_hosts 2>/dev/null
		fi
	done

	echo " - create mock NAS folders"
	mkdir -p /opt/mock_nas/Multimedia/{Anime,Movies,Music,Podcasts,TV\ Shows}
	mkdir -p /opt/mock_nas/Download/done
	mkdir -p /opt/mock_nas/Download/torrent/{pending,done,auto-load,torrent-files}
	mkdir -p /opt/mock_nas/Download/newsgroup/{nzbFiles,pending,done}
	mkdir -p /opt/mock_nas/Download/pyload
	mkdir -p /opt/mock_nas/Nextcloud/data
	mkdir -p /opt/mock_nas/NVR
	mkdir -p /opt/mock_nas/Paperless/{consume,media}
	mkdir -p /opt/mock_nas/Syncthing
	chmod -R 777 /opt/mock_nas
	# Permissions for Nextcloud
	chown 33:33 /opt/mock_nas/Nextcloud/data
	chmod 700 /opt/mock_nas/Nextcloud/data

	echo " - install NFS Server"
	apt-get -q -y install nfs-kernel-server

	network_cidr=$(
		python - <<'__EOF__'
import yaml
config = yaml.load(open("/opt/provision/vagrant/Vagrantconfig.yaml", "r"), yaml.SafeLoader)
print(config['common']['network_cidr'])
__EOF__
	)
	echo "    * Allowing "$network_cidr

	cat <<EOF >/etc/exports
/opt/mock_nas/Multimedia $network_cidr(rw)
/opt/mock_nas/Download $network_cidr(rw)
/opt/mock_nas/Nextcloud $network_cidr(rw)
/opt/mock_nas/NVR $network_cidr(rw)
/opt/mock_nas/Paperless $network_cidr(rw)
/opt/mock_nas/Syncthing $network_cidr(rw)
EOF
	systemctl restart nfs-kernel-server

	ufw allow NFS
fi
