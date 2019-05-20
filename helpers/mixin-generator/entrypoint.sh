#!/usr/bin/env sh

echo "===================================================================================================="
echo "Kubernetes mixin"
cd /opt
echo " - cloning ..."
git clone https://github.com/kubernetes-monitoring/kubernetes-mixin
cd kubernetes-mixin
echo " - installing requirements ..."
jb install

echo " - generating prometheus_alerts ..."
make prometheus_alerts.yaml
echo " - generating prometheus_rules ..."
make prometheus_rules.yaml
echo " - generating dashboards_out ..."
make dashboards_out

echo " -copying generated files"
mkdir -p /out/kubernetes-mixin
cp -v prometheus_*.yaml /out/kubernetes-mixin/
cp -Rv dashboards_out /out/kubernetes-mixin/

echo "===================================================================================================="


echo "===================================================================================================="
echo "Gluster mixin"

cd /opt
echo " - cloning ..."
git clone https://github.com/gluster/gluster-mixins
cd gluster-mixins
echo " - installing requirements ..."
jb install

echo " - generating prometheus_alerts ..."
make prometheus_alerts.yaml
echo " - generating prometheus_rules ..."
make prometheus_rules.yaml
echo " - generating dashboards_out ..."
make dashboards_out

echo " -copying generated files"
mkdir -p /out/gluster-mixins
cp -v prometheus_*.yaml /out/gluster-mixins/
cp -Rv dashboards_out /out/gluster-mixins/

echo "===================================================================================================="

chmod -R 777 /out
