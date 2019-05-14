#!/usr/bin/env bash

echo ""
echo "Deleting OpenLDAP StatefulSet"
su user -c "kubectl delete statefulsets openldap"

echo ""
echo "Deleting OpenLDAP PVCs"
su user -c "kubectl delete persistentvolumeclaims openldap-config-pv-claim-openldap-0"
su user -c "kubectl delete persistentvolumeclaims openldap-data-pv-claim-openldap-0"
su user -c "kubectl delete persistentvolumeclaims openldap-run-pv-claim-openldap-0"
 
echo ""
echo "Deleting OpenLDAP PVs"
su user -c "kubectl delete persistentvolume openldap-config"
su user -c "kubectl delete persistentvolume openldap-data"
su user -c "kubectl delete persistentvolume openldap-run"

echo ""
echo "Stopping Gluster volumes"
gluster --mode=script volume stop openldap-config
gluster --mode=script volume stop openldap-data
gluster --mode=script volume stop openldap-run

echo ""
echo "Deleting Gluster volumes"
gluster --mode=script volume delete openldap-config
gluster --mode=script volume delete openldap-data
gluster --mode=script volume delete openldap-run

echo ""
echo "Disable auto brick mount"
ssh 192.168.100.10 "sed -i 's|^/dev/data_vg/openldap-.*||' /etc/fstab"
ssh 192.168.100.11 "sed -i 's|^/dev/data_vg/openldap-.*||' /etc/fstab"
ssh 192.168.100.12 "sed -i 's|^/dev/data_vg/openldap-.*||' /etc/fstab"

echo ""
echo "Unmounting bricks"
ssh 192.168.100.10 "umount /data/glusterfs/openldap-config/brick1"
ssh 192.168.100.10 "umount /data/glusterfs/openldap-data/brick1"
ssh 192.168.100.10 "umount /data/glusterfs/openldap-run/brick1"
ssh 192.168.100.11 "umount /data/glusterfs/openldap-config/brick1"
ssh 192.168.100.11 "umount /data/glusterfs/openldap-data/brick1"
ssh 192.168.100.11 "umount /data/glusterfs/openldap-run/brick1"
ssh 192.168.100.12 "umount /data/glusterfs/openldap-config/brick1"
ssh 192.168.100.12 "umount /data/glusterfs/openldap-data/brick1"
ssh 192.168.100.12 "umount /data/glusterfs/openldap-run/brick1"

echo ""
echo "Deleting OpenLDAP lvs"
ssh 192.168.100.10 "lvremove -y --force /dev/data_vg/openldap-config"
ssh 192.168.100.10 "lvremove -y --force /dev/data_vg/openldap-data"
ssh 192.168.100.10 "lvremove -y --force /dev/data_vg/openldap-run"
ssh 192.168.100.11 "lvremove -y --force /dev/data_vg/openldap-config"
ssh 192.168.100.11 "lvremove -y --force /dev/data_vg/openldap-data"
ssh 192.168.100.11 "lvremove -y --force /dev/data_vg/openldap-run"
ssh 192.168.100.12 "lvremove -y --force /dev/data_vg/openldap-config"
ssh 192.168.100.12 "lvremove -y --force /dev/data_vg/openldap-data"
ssh 192.168.100.12 "lvremove -y --force /dev/data_vg/openldap-run"

echo ""
echo "Re-create OpenLDAP lvs"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-storage

echo ""
echo "Provision OpenLDAP"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-auth-openldap
