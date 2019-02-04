#!/usr/bin/env bash

mode=$1

if [ "$mode" != "ansible" ] ; then
	mode="node"
fi 

echo ""
echo "=================================================="
echo "Updating package list and distribution"
echo "=================================================="

#if [ "$mode" == "ansible" ] ; then
	#echo " - add stretch-backports"
	#echo "deb http://ftp.fr.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list
#fi

echo " - update"
apt-get -y update

echo " - upgrade"
apt-get -q -y upgrade

#echo " - dist-upgrade"
#apt-get -q -y dist-upgrade

echo " - install python"
apt-get -q -y install python

mkdir -p /root/.ssh

if [ "$mode" == "ansible" ] ; then
	echo " - install ansible from"
	# only 2.6 is available in stretch-backports, so we use pip to get the latest 2.7
	#apt-get -q -y -t stretch-backports install ansible
	apt-get -q -y install python-pip
	pip install ansible==2.7.6
	
	echo " - install ansible ssh keys"
	cp -R /vagrant/ssh/* /root/.ssh/

	echo " - add hosts to known hosts"
	touch /root/.ssh/known_hosts
	host_ips=$(python - <<'__EOF__'
import yaml
config = yaml.load(open("/opt/provision/vagrant/Vagrantconfig.yaml", "r"))
print(config['master']['ip'])
for node_conf in config['nodes']:
  print(node_conf['ip'])
__EOF__
)
	for host_ip in $host_ips ; do
		echo "    * "$host_ip
		knownKey=$(ssh-keygen -F $host_ip)
		if [ "$knownKey" == "" ] ; then
			ssh-keyscan -H -T 10 $host_ip >> /root/.ssh/known_hosts 2>/dev/null
		fi
	done

	echo " - create mock NAS folders"
	mkdir -p /opt/mock_nas/Multimedia/{Music,Podcasts}

	echo " - install NFS Server"
	apt-get -q -y install nfs-kernel-server

	network_cidr=$(python - <<'__EOF__'
import yaml
config = yaml.load(open("/opt/provision/vagrant/Vagrantconfig.yaml", "r"))
print(config['common']['network_cidr'])
__EOF__
)
		echo "    * Allowing "$network_cidr

	cat << EOF > /etc/exports
/opt/mock_nas/Multimedia $network_cidr(rw)
EOF
	systemctl restart nfs-kernel-server
fi

echo " - add ansible key to authorized keys"
touch /root/.ssh/authorized_keys
searchLocalKey=$(grep -c "$(cat /vagrant/ssh/id_rsa.pub)" /root/.ssh/authorized_keys)
if [ $searchLocalKey -eq 0 ] ; then
	cat /vagrant/ssh/id_rsa.pub >> /root/.ssh/authorized_keys
fi

chmod -R 700 /root/.ssh

if [ "$mode" == "node" ] ; then
	echo " - install LVM"
	apt-get -q -y install lvm2
	
	echo " - preparing docker disk"
	# Create a new partition table with a single 'Linux native' partition
	echo 'type=83' | sfdisk /dev/sdb
	mkfs.ext4 /dev/sdb1
	mkdir -p /var/lib/docker
	echo "/dev/sdb1 /var/lib/docker ext4" >> /etc/fstab
	mount -a
	
	echo " - preparing data disk for LVM"
	# Create a new partition table with a single LVM partition
	echo 'type=8e' | sfdisk /dev/sdc
	pvcreate /dev/sdc1
	vgcreate kubernetes_vg /dev/sdc1
fi
