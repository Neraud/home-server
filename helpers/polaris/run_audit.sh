#!/usr/bin/env sh

if [ -f ./polaris ]; then
    echo "Polaris is already downloaded"
else
    echo "Download Polaris"
    curl -L -o /tmp/polaris_0.4.0_Linux_x86_64.tar.gz https://github.com/FairwindsOps/polaris/releases/download/0.4.0/polaris_0.4.0_Linux_x86_64.tar.gz
    tar xzf /tmp/polaris_0.4.0_Linux_x86_64.tar.gz polaris
    rm /tmp/polaris_0.4.0_Linux_x86_64.tar.gz
fi

echo "Generating report ..."
./polaris -audit -kubeconfig /etc/kubernetes/admin.conf -config ./config.yaml -output-format yaml >report.yaml
echo "Report available report.yaml"
