# Vagrant

The Vagrantfile creates 4 *similar* guests :

| Type           | Cores |  RAM  | Storage |
| -------------- | :---: | :---: | :-----: |
| master-test-1  |   3   |  6G   |    -    |
| master-test-2  |   6   |  6G   |   96G   |
| master-test-3  |   6   |  6G   |   96G   |
| node-test-home |   2   |  1G   |   16G   |

These settings are configured in `Vagrantconfig.yaml`, feel free to change them or add mode nodes.

CPUs are capped at 33% usage (`cpu_execution_cap`) to avoid destroying a poor host machine.

`master-test-1` is also used as the ansible controller.

## NAS

To simulate a NAS, NFS Server is installed on `master-test-1` and exports the content of `/opt/mock_nas` to other hosts as NFS shares.

## Test hosts

To test the deployed services, you will have to add the following domains to your hosts file :

```ini
192.168.100.100 k8s.test
192.168.100.100 lemonldap.auth.k8s.test
192.168.100.101 lemonldap.auth.intra.k8s.test
192.168.100.101 phpldapadmin.auth.intra.k8s.test
192.168.100.101 kube.infra.intra.k8s.test
192.168.100.101 mailhog.infra.intra.k8s.test
192.168.100.101 docker-registry-ui.infra.intra.k8s.test
192.168.100.101 pihole.infra.intra.k8s.test
192.168.100.101 unifi.infra.intra.k8s.test
192.168.100.101 elasticsearch.log.intra.k8s.test
192.168.100.101 kibana.log.intra.k8s.test
192.168.100.101 prometheus.monitoring.intra.k8s.test
192.168.100.101 alertmanager.monitoring.intra.k8s.test
192.168.100.101 grafana.monitoring.intra.k8s.test
192.168.100.101 esphome.home.intra.k8s.test
192.168.100.100 homer.web.k8s.test
192.168.100.100 ttrss.web.k8s.test
192.168.100.100 gotify.web.k8s.test
192.168.100.101 infra.k8s.test
192.168.100.100 auth.k8s.test
192.168.100.100 home.k8s.test
192.168.100.100 web.k8s.test
192.168.100.101 dev.k8s.test
192.168.100.101 stream.k8s.test
192.168.100.101 dl.k8s.test
```

## User

To avoid using `root` directly, a standard user is created. For the Vagrant environment, it's simply named `user`.

This `user` can :

* `sudo` without password
* SSH to other machines without password (using RSA keys)
* use kubectl
* use docker

## HTTPS

All HTTPS certificates are self-signed, so you'll need to accept a warning the first time you access a domain.

The playbook supports [Let's Encrypt](https://letsencrypt.org/) to generate valid certificates on a production environment.

## Credentials

Unless listed, all credentials are `user` / `Passw0rd`.

For more information, take a look at the [authentication and authorization page](docs/Authentication_authorization.md).

## Services

The following services are deployed :

| Service                                                          | Test URL                                             | Description                                            |
| ---------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------ |
| [Kubernetes dashboard](https://github.com/kubernetes/dashboard/) | <https://kube.infra.intra.k8s.test/>                 | Kubernetes dashboard                                   |
| [Docker Registry](https://docs.docker.com/registry/deploying/)   | -                                                    | Docker Registry                                        |
| [Docker Registry UI](https://github.com/Quiq/docker-registry-ui) | <https://docker-registry-ui.infra.intra.k8s.test>    | Web UI for Docker Registry                             |
| [OpenLDAP](https://www.openldap.org/)                            | -                                                    | Open source Lightweight Directory Access Protocol      |
| [LemonDAP](https://lemonldap-ng.org/welcome/)                    | <https://lemonldap.auth.intra.k8s.test/manager.html> | Web Single Sign On and Access Management Free Software |
| [phpLDAPadmin](http://phpldapadmin.sourceforge.net/)             | <https://phpldapadmin.auth.intra.k8s.test/>          | Web-based LDAP browser                                 |
| [ZoneMTA](https://github.com/zone-eu/zone-mta)                   | -                                                    | Modern outbound SMTP relay                             |
| [MailHog](https://github.com/mailhog/MailHog)                    | <https://mailhog.infra.intra.k8s.test/>              | MailHog is an email testing tool for developers        |
| [PiHole](https://pi-hole.net/)                                   | <https://pihole.infra.intra.k8s.test/admin/>         | A black hole for Internet advertisements               |
| [Gotify](https://gotify.net/)                                    | <https://gotify.web.k8s.test>                        | A simple server for sending and receiving messages     |
| [Prometheus](https://prometheus.io/)                             | <https://prometheus.monitoring.intra.k8s.test>       | Monitoring solution                                    |
| [AlertManager](https://github.com/prometheus/alertmanager)       | <https://alertmanager.monitoring.intra.k8s.test>     | Alert manager for Prometheus                           |
| [Grafana](https://grafana.com/)                                  | <https://grafana.monitoring.intra.k8s.test>          | Platform for beautiful analytics and monitoring        |
| [Fluent Bit](https://fluentbit.io/)                              | -                                                    | Lightweight log Processor and Forwarder                |
| [FluentD](https://www.fluentd.org/)                              | -                                                    | Log Processor and Forwarder                            |
| [ElasticSearch](https://www.elastic.co/products/elasticsearch)   | <https://elasticsearch.log.intra.k8s.test>           | Distributed, RESTful search and analytics engine       |
| [Kibana](https://www.elastic.co/products/kibana)                 | <https://kibana.log.intra.k8s.test>                  | Visualize your Elasticsearch data                      |
| [Unifi Controller](https://unifi-sdn.ubnt.com/)                  | <https://unifi.infra.intra>                          | Controller for Unifi devices                           |
| [HomeAssistant](https://www.home-assistant.io/)                  | <https://home.k8s.test/>                             | Home automation                                        |
| [ESPHome](https://esphome.io/index.html)                         | <https://esphome.home.intra>                         | System to control your ESP8266/ESP32                   |
| [Zwavejs2Mqtt](https://zwave-js.github.io/zwavejs2mqtt/)         | <https://home.k8s.test/zwave/>                       | Fully configurable Zwave Gateway and Control Panel     |
| [Node-RED](https://nodered.org/)                                 | <https://home.k8s.test/node-red/>                    | Flow-based programming for the IoT                     |
| [Mosquitto](https://mosquitto.org/)                              | <mqtts://home.k8s.test>                              | MQTT broker                                            |
| [RoomAssistant](https://github.com/mKeRix/room-assistant)        | -                                                    | Presence tracking                                      |
| [TT-RSS](https://tt-rss.org/)                                    | <https://ttrss.web.k8s.test>                         | News feed (RSS/Atom) reader and aggregator             |
| [Homer](https://github.com/bastienwirtz/homer)                   | <https://homer.web.k8s.test>                         | A very simple static homepage for your server          |
| [Gitlab](https://about.gitlab.com/)                              | <https://dev.k8s.test/gitlab/>                       | Source code management and CI/CD                       |
| [Jellyfin](https://jellyfin.org/)                                | <https://stream.k8s.test/jellyfin/>                  | Video streaming                                        |
| [Airsonic](https://airsonic.github.io/)                          | <https://stream.k8s.test/airsonic/>                  | Music streaming                                        |
| [Sickchill](https://sickchill.github.io/)                        | <https://dl.k8s.test/sickchill/>                     | Automatic Video Library Manager for TV Shows.          |
| [Deluge](https://deluge-torrent.org/)                            | <https://dl.k8s.test/deluge/>                        | Torrent client                                         |
| [pyload](https://pyload.net/)                                    | <https://dl.k8s.test/pyload/>                        | HTTP download manager                                  |
| [SABnzbd](https://sabnzbd.org/)                                  | <https://dl.k8s.test/sabnzbd/>                       | Binary newsreader                                      |

Once the Vagrant environment is started, you can easily list all the service URLs on the [Homer dashboard](https://web.k8s.test/homer/).

### Kubernetes dashboard

An `admin-user` service account is automatically created by the playbook.

To login, you need to fetch the associated token.

You can do so using a terminal (assuming you start at the project root) :

```shell
[your_account@your_computer$] cd vagrant
[your_account@your_computer$] vagrant ssh master
[vagrant@master$] sudo su - user
[user@master$] kubectl --namespace=infra-kubernetes-dashboard describe secrets $(kubectl --namespace=infra-kubernetes-dashboard get secrets | awk '/dashboard-admin-user-token/ { print $1 }')
```

### Docker Registry UI

Docker Registry UI is installed and configured to show the images stored in the local private registry.

The LemonLDAP user name is sent to Docker Registry UI, and usernames added in the `docker_registry_ui_admin_users` variables are allowed to remove tags from the registry (by default `user` is allowed).

### OpenLDAP

OpenLDAP is installed and configured for the base domain.
`admin` and `config` accounts are created with a default password `Passw0rd`.

It enforces TLS with a self-signed CA.
This `ca.crt` is available in the Kubernetes secret `cluster-ca`

To test the LDAP connection, you can use :

```shell
[user@master$] kubectl --namespace=auth-openldap run test-ldap -it --rm --image=particlekit/ldap-client --restart=Never --overrides='
{
    "spec": {
      "containers": [
        {
          "name": "test-ldap",
          "image": "particlekit/ldap-client",
          "args": [
            "ldapsearch", "-x", "-H", "ldaps://openldap.auth-openldap.svc.cluster.local", "-b", "dc=k8s,dc=test", "-D", "cn=admin,dc=k8s,dc=test", "-w", "Passw0rd"
          ],
          "stdin": true,
          "stdinOnce": true,
          "tty": true,
          "env": [
              { "name": "LDAPTLS_CACERT", "value": "/certs/ca.crt" },
              { "name": "LDAPTLS_REQCERT", "value": "demand" }
          ],
          "volumeMounts": [{
            "mountPath": "/certs",
            "name": "certs-volume"
          }]
        }
      ],
      "volumes": [{
        "name":"certs-volume",
        "secret":{"secretName": "cluster-ca"}
      }]
    }
}'
```

### LemonDAP

LemonLDAP is used as a SSO for all applications.
User, credentials and groups are stored in OpenLDAP, while access rules are configured in LemonLDAP.

User `user` has access to everything.
You can add a TOTP device for `user` and force its use by setting the `requiredAuthnLevel` property under each domain in `lemonldap_location_rules` in `ansible/inventories/vagrant/group_vars/all/apps/auth-lemonldap`

### phpLDAPadmin

You can login using the `admin`/`Passw0rd` account to manage the LDAP.

### ZoneMTA

ZoneMTA is used to collect all emails sent by applications on the platform and forward them to another MTA.
By default, it forwards to MailHog for debugging purposes. But it can be set up to forward to a proper MTA (using a gmail account for example)

You can easily test ZoneMTA by sending a email via the command line :

```shell
[root@master$] apt-get -q -y install swaks libnet-ssleay-perl libnet-dns-perl

[user@master$] swaks \
    --to "someone@example.com" --from "you@example.com" \
    --auth --auth-user=smtp --auth-password=Passw0rd \
    -tls \
    --server $(kubectl --namespace=infra-zonemta get service zonemta -o=jsonpath='{.spec.clusterIP}'):587 \
    --body "This is the message body sent to ZoneMTA" 
```

### MailHog

MailHog is used to capture all emails sent by the various deployed services.

Out of the box, it is only used for testing purposes : you can view those emails using a web interface.

You can easily test MailHog by sending a email via the command line :

```shell
[root@master$] apt-get -q -y install swaks

# Allow all smtp ingress tp mailhog
[user@master$] cat <<EOF | kubectl apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-to-test-mailhog
  namespace: infra-mailhog
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: mailhog
      app.kubernetes.io/component: mailhog
  ingress:
    # Allow smtp from everywhere
    - ports:
        - port: smtp
      from: []
EOF

[user@master$] swaks \
    --to "someone@example.com" --from "you@example.com" \
    --server $(kubectl --namespace=infra-mailhog get service mailhog -o=jsonpath='{.spec.clusterIP}'):1025 \
    --body "This is the message body sent to MailHog"

[user@master$] kubectl --namespace=infra-mailhog delete networkpolicies allow-to-test-mailhog
```

### PiHole

PiHole is configured.

The web admin uses the password : `Passw0rd`.

To test it, you can use nslookup :

```shell
[root@master$] apt-get -q -y install dnsutils

# This one is resolved
[user@master$] nslookup google.com 192.168.100.23
Server:         192.168.100.23
Address:        192.168.100.23#53

Non-authoritative answer:
Name:   google.com
Address: 216.58.215.46
Name:   google.com
Address: 2a00:1450:4007:80a::200e

# This one is blocked
[user@master$] nslookup ad.doubleclick.net 192.168.100.23
Server:         192.168.100.23
Address:        192.168.100.23#53

Name:   ad.doubleclick.net
Address: 0.0.0.0
Name:   ad.doubleclick.net
Address: ::
```

### Gotify

Gotify can be used to send notifications.

2 users are created :

* `admin` / `Passw0rd`
* `user` / `Passw0rd`

`user` also has a `sample` application, and you can send a test message via the command line :

```shell
[user@master$] token=$(curl -s -k -H "Host: gotify.web.k8s.test" -u user:Passw0rd https://192.168.100.100/application | jq -r '.[] | select(.name=="sample") | .token')
[user@master$] curl -X POST -s -k -H "Host: gotify.web.k8s.test" -H "X-Gotify-Key: $token" https://192.168.100.100/message -F "title=Sample title" -F "message=Sample message"
```

### Prometheus & AlertManager

Prometheus & AlertManager are deployed, and configured to gather metrics from the usual exporters :

* [node_exporter](https://github.com/prometheus/node_exporter)
* [kube_state_metrics](https://github.com/kubernetes/kube-state-metrics)

Their deployment manifests and configurations are based on the examples provided by the contrib project [Kube Prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus)

### Grafana

Grafana is deployed and configured to use Prometheus as a data source.

Default Kubernetes dashboards are already created, based on [Kube Prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus).

You can use the default admin account : `admin` / `Passw0rd`

### Fluent Bit

Fluent Bit is deployed on all nodes to capture logs and forward them to ElasticSearch.

### ElasticSearch

The [OpenDistro](https://opendistro.github.io/for-elasticsearch/) variant of ElasticSearch is deployed.

You can test the 'E' part of the EFK stack by calling : <https://elasticsearch.log.intra.k8s.test/_cluster/state?pretty>

You can use the exporter's user to test : `exporter` / `password`

### Kibana

The [OpenDistro](https://opendistro.github.io/for-elasticsearch/) variant of Kibana is deployed and configured to read data from ElasticSearch.

Saved Objects (sources, visualizations, dashboards) are loaded from the `ansible/install_applications/roles/logging-kibana.deploy/app/config/saved_objects` folder.

To add new objects, you can :

* configure them via the Kibana web application
* export them using the `kibana_sav_objects.py` script
* save the json files under the `ansible/install_applications/roles/logging-kibana.deploy/app/config/saved_objects` folder

### Unifi Controller

The Unifi Controller is installed.

The Web GUI will be available using the standard ReverseProxy + Ingress chain.

The controller requires a few other non-http ports, and must be available from outside the cluster. It is exposed using a MetalLB loadbalancer (`unifi-private-(tcp|udp)` services).

When setting the controller up, the inform URL setting will need to be changed to : `http://[unifi_private_ip]:8080/inform`

### HomeAssistant

HomeAssistant will prompt for the 1st user creation.

The deployment also prepares and configures a MySQL database to use for HomeAssistant [recorder](https://www.home-assistant.io/components/recorder/).

### Zwavejs2Mqtt

Zwavejs2Mqtt is not automatically installed for Vagrant. It requires access to a ZWave serial device (most probably exposed on a TCP port via ser2net).

If configured and deployed, it can be accessed using `user` / `Passw0rd` on teh web ui.

It can be added as an integration in Home Assistant using the following URL : `ws://zwavejs2mqtt.home-zwavejs2mqtt.svc.cluster.local:3000`.

### Mosquitto

The MQTT broker Mosquitto is deployed.

A Fake sensor is created in HomeAssistant, based on the topic `test/test_sensor`.

To push values on this sensor :

```shell
[user@master$] kubectl --namespace=home-mosquitto \
  run test-mqtt-pub -it --rm --image=aksakalli/mqtt-client --restart=Never \
  --labels="app.kubernetes.io/name=mosquitto,app.kubernetes.io/component=test" \
  --overrides='
{
    "spec": {
      "containers": [
        {
          "name": "test-mqtt-pub",
          "image": "aksakalli/mqtt-client",
          "args": [
            "pub", "-h", "mosquitto.home-mosquitto.svc.cluster.local", "-p", "8883", "--cafile", "/certs/ca.crt", "-u", "user", "-P", "Passw0rd", "-t", "test/test_sensor", "-m", "Mock Value"
          ],
          "stdin": true,
          "stdinOnce": true,
          "tty": true,
          "volumeMounts": [{
            "mountPath": "/certs",
            "name": "certs-volume"
          }]
        }
      ],
      "volumes": [{
        "name":"certs-volume",
        "secret":{"secretName": "cluster-ca"}
      }]
    }
}'
```

To debug all messages sent via Mosquitto :

```shell
[user@master$] kubectl --namespace=home-mosquitto \
  run test-mqtt-sub -it --rm --image=aksakalli/mqtt-client --restart=Never \
  --labels="app.kubernetes.io/name=mosquitto,app.kubernetes.io/component=test" \
  --overrides='
{
    "spec": {
      "containers": [
        {
          "name": "test-mqtt-sub",
          "image": "aksakalli/mqtt-client",
          "args": [
            "sub", "-h", "mosquitto.home-mosquitto.svc.cluster.local", "-p", "8883", "--cafile", "/certs/ca.crt", "-u", "user", "-P", "Passw0rd", "-t", "#"
          ],
          "stdin": true,
          "stdinOnce": true,
          "tty": true,
          "volumeMounts": [{
            "mountPath": "/certs",
            "name": "certs-volume"
          }]
        }
      ],
      "volumes": [{
        "name":"certs-volume",
        "secret":{"secretName": "cluster-ca"}
      }]
    }
}'
```

### Node-RED

Node-RED addons can be installed via the web interface.

A sample flow is already deployed to show how Node-RED integrates with HomeAssistant.
It requires :

* generating a HomeAssistant long lived access token (from the HomeAssistant profile page)
* configuring the HomeAssistant Server on Nod-RED

The sample flow is commented to help these steps.

### Room Assistant

RoomAssistant is deployed and configured to use Mosquitto.

A sample Shell script is used to generate a random number and push it as a sensor on Home Assistant.

The real use case would be to use either a real shell, and/or enable the BLE plugin to detect room presence.

### TT-RSS

TT-RSS is installed.
The default account is `admin` / `password`.

### Homer

Homer is installed.

Apps deployed in the cluster are added on the dashboard.

### Gitlab

Gitlab is installed using the omnibus package.

The `root` account password is set the first time the site is displayed.
The default `user` account (from OpenLDAP) also has access.

### Jellyfin

Jellyfin is deployed and configured.
The default `user` account (from OpenLDAP) has admin access.

### Airsonic

Airsonic is deployed and configured to look for music on the NAS share by default.

### Sickchill

Sickchill is installed.

Search providers are not configured by default.

The mock NAS storage is used as media storage.

### Deluge

Deluge is installed.

The mock NAS storage is used as media storage.

The webui uses the password : `Passw0rd`.

### pyload

pyLoad is installed.

The mock NAS storage is used as media storage.

A default `pyload` / `Passw0rd` user is created.

### SABnzbd

pyLoad is installed.

The mock NAS storage is used as media storage.

A default `sabnzbd` / `Passw0rd` user is created.

[nzbToMedia](https://github.com/clinton-hall/nzbToMedia) is added and configured to notify Sickchill of finished downloads.

## Backups

The backup tools are deployed and configured on the Vagrant guests.

However, to keep it simple, each host uses a local restic repository saved `/tmp`.
