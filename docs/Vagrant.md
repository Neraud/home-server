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

You can use a local configuration `Vagrantconfig.local.yaml` not tracked in git to change those settings without change the `Vagrantconfig.yaml` itself.

Be careful not to allocate more vCPUs than the physical cores available on your host.

At least under Windows, with a 12 vCPUs test VM on a 12c/24t host, the performance greatly decreases and htop shows huge kernel CPU spikes.

## NAS

To simulate a NAS, NFS Server is installed on `master-test-1` and exports the content of `/opt/mock_nas` to other hosts as NFS shares.

## Test hosts

To test the deployed services, you will have to add the following domains to your hosts file :

```ini
192.168.100.100 k8s.test

192.168.100.100 lemonldap.auth.k8s.test
192.168.100.101 lemonldap.auth.intra.k8s.test
192.168.100.101 phpldapadmin.auth.intra.k8s.test

192.168.100.100 ntfy.infra.k8s.test
192.168.100.101 kube.infra.intra.k8s.test
192.168.100.101 longhorn.infra.intra.k8s.test
192.168.100.101 mailhog.infra.intra.k8s.test
192.168.100.101 docker-registry-ui.infra.intra.k8s.test
192.168.100.101 unifi.infra.intra.k8s.test

192.168.100.101 elasticsearch.log.intra.k8s.test
192.168.100.101 kibana.log.intra.k8s.test

192.168.100.101 prometheus.monitoring.intra.k8s.test
192.168.100.101 alertmanager.monitoring.intra.k8s.test
192.168.100.101 grafana.monitoring.intra.k8s.test

192.168.100.100 homeassistant.home.k8s.test
192.168.100.101 esphome.home.intra.k8s.test
192.168.100.101 zwavejsui.home.intra.k8s.test
192.168.100.101 zigbee2mqtt.home.intra.k8s.test
192.168.100.101 nodered.home.intra.k8s.test
192.168.100.101 frigate.home.intra.k8s.test


192.168.100.100 homepage.tool.k8s.test
192.168.100.100 miniflux.tool.k8s.test
192.168.100.101 nextcloud.tool.intra.k8s.test
192.168.100.101 paperless.tool.intra.k8s.test
192.168.100.101 olivetin.tool.intra.k8s.test
192.168.100.101 syncthing.tool.intra.k8s.test
192.168.100.101 syncthing-discovery.tool.intra.k8s.test

192.168.100.101 airsonic.stream.intra.k8s.test
192.168.100.101 jellyfin.stream.intra.k8s.test

192.168.100.101 gitea.dev.intra.k8s.test
192.168.100.101 minio.dev.intra.k8s.test
192.168.100.101 argo-workflows.dev.intra.k8s.test

192.168.100.101 sickchill.dl.intra.k8s.test
192.168.100.101 deluge.dl.intra.k8s.test
192.168.100.101 pyload.dl.intra.k8s.test
192.168.100.101 sabnzbd.dl.intra.k8s.test
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

| Service                                                          | Test URL                                             | Description                                                       |
| ---------------------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------- |
| [Kubernetes dashboard](https://github.com/kubernetes/dashboard/) | <https://kube.infra.intra.k8s.test/>                 | Kubernetes dashboard                                              |
| [Longhorn Management UI](https://github.com/longhorn/longhorn-ui)| <https://longhorn.infra.intra.k8s.test>              | Longhorn Managmeent UI                                            |
| [Docker Registry](https://docs.docker.com/registry/deploying/)   | -                                                    | Docker Registry                                                   |
| [Docker Registry UI](https://github.com/Quiq/docker-registry-ui) | <https://docker-registry-ui.infra.intra.k8s.test>    | Web UI for Docker Registry                                        |
| [OpenLDAP](https://www.openldap.org/)                            | -                                                    | Open source Lightweight Directory Access Protocol                 |
| [LemonDAP](https://lemonldap-ng.org/welcome/)                    | <https://lemonldap.auth.intra.k8s.test/manager.html> | Web Single Sign On and Access Management Free Software            |
| [phpLDAPadmin](http://phpldapadmin.sourceforge.net/)             | <https://phpldapadmin.auth.intra.k8s.test/>          | Web-based LDAP browser                                            |
| [Crowdsec](https://www.crowdsec.net/)                            | -                                                    | Collaborative malicious activity detection and remediation tool   |
| [ZoneMTA](https://github.com/zone-eu/zone-mta)                   | -                                                    | Modern outbound SMTP relay                                        |
| [MailHog](https://github.com/mailhog/MailHog)                    | <https://mailhog.infra.intra.k8s.test/>              | MailHog is an email testing tool for developers                   |
| [Blocky](https://0xerr0r.github.io/blocky/)                      | -                                                    | DNS proxy and ad-blocker for the local network                    |
| [Ntfy](https://ntfy.sh/)                                         | <https://ntfy.infra.k8s.test>                        | Send push notifications to your phone or desktop via PUT/POST     |
| [Prometheus](https://prometheus.io/)                             | <https://prometheus.monitoring.intra.k8s.test>       | Monitoring solution                                               |
| [AlertManager](https://github.com/prometheus/alertmanager)       | <https://alertmanager.monitoring.intra.k8s.test>     | Alert manager for Prometheus                                      |
| [Grafana](https://grafana.com/)                                  | <https://grafana.monitoring.intra.k8s.test>          | Platform for beautiful analytics and monitoring                   |
| [Fluent Bit](https://fluentbit.io/)                              | -                                                    | Lightweight log Processor and Forwarder                           |
| [FluentD](https://www.fluentd.org/)                              | -                                                    | Log Processor and Forwarder                                       |
| [ElasticSearch](https://www.elastic.co/products/elasticsearch)   | <https://elasticsearch.log.intra.k8s.test>           | Distributed, RESTful search and analytics engine                  |
| [Kibana](https://www.elastic.co/products/kibana)                 | <https://kibana.log.intra.k8s.test>                  | Visualize your Elasticsearch data                                 |
| [Unifi Controller](https://unifi-sdn.ubnt.com/)                  | <https://unifi.infra.intra>                          | Controller for Unifi devices                                      |
| [HomeAssistant](https://www.home-assistant.io/)                  | <https://homeassistant.home.k8s.test>                | Home automation                                                   |
| [ESPHome](https://esphome.io/index.html)                         | <https://esphome.home.intra>                         | System to control your ESP8266/ESP32                              |
| [Z-Wave JS UI](https://zwave-js.github.io/zwavejsui/)            | <https://zwavejsui.home.intra.k8s.test>              | Fully configurable Zwave Gateway and Control Panel                |
| [Zigbee2MQTT](https://www.zigbee2mqtt.io/)                       | <https://zigbee2mqtt.home.intra.k8s.test>            | Zigbee to MQTT bridge, get rid of your proprietary Zigbee bridges |
| [Frigate](https://blakeblackshear.github.io/frigate/)            | <https://frigate.home.intra.k8s.test>                | Local NVR designed for Home Assistant with AI object detection    |
| [Node-RED](https://nodered.org/)                                 | <https://nodered.home.intra.k8s.test>                | Flow-based programming for the IoT                                |
| [Mosquitto](https://mosquitto.org/)                              | <mqtts://home.k8s.test>                              | MQTT broker                                                       |
| [RoomAssistant](https://github.com/mKeRix/room-assistant)        | -                                                    | Presence tracking                                                 |
| [Homepage](https://gethomepage.dev/)                             | <https://homepage.tool.k8s.test/>                    | A highly customizable homepage with service API integrations      |
| [Miniflux](https://miniflux.app/)                                | <https://miniflux.tool.k8s.test/>                    | Miniflux is a minimalist and opinionated feed reader              |
| [Reminiflux](https://github.com/reminiflux/reminiflux)           | <https://miniflux.tool.k8s.test/reminiflux/>         | Alternative web frontend for miniflux                             |
| [Nextcloud](https://nextcloud.com/)                              | <https://nextcloud.tool.intra.k8s.test>              | The self-hosted productivity platform that keeps you in control   |
| [PaperlessNGX](https://github.com/paperless-ngx/paperless-ngx)   | <https://paperless.tool.intra.k8s.test>              | Scan & OCR documents                                              |
| [OliveTin](https://docs.olivetin.app/)                           | <https://olivetin.tool.intra.k8s.test>               | Access to predefined shell commands from a web interface.         |
| [Syncthing](https://syncthing.net/)                              | <https://syncthing.tool.intra.k8s.test/>             | Continuous file synchronization                                   |
| [Gitea](https://gitea.io/)                                       | <https://gitea.dev.intra.k8s.test>                   | Lightweight code hosting solution written in Go.                  |
| [Jellyfin](https://jellyfin.org/)                                | <https://jellyfin.stream.intra.k8s.test>             | Video streaming                                                   |
| [Airsonic](https://airsonic.github.io/)                          | <https://airsonic.stream.intra>                      | Music streaming                                                   |
| [Sickchill](https://sickchill.github.io/)                        | <https://sickchill.dl.intra.k8s.test>                | Automatic Video Library Manager for TV Shows.                     |
| [Deluge](https://deluge-torrent.org/)                            | <https://deluge.dl.intra.k8s.test>                   | Torrent client                                                    |
| [pyload](https://pyload.net/)                                    | <https://pyload.dl.intra.k8s.test>                   | HTTP download manager                                             |
| [SABnzbd](https://sabnzbd.org/)                                  | <https:/sabnzbd.dl.intra.k8s.test>                   | Binary newsreader                                                 |

Once the Vagrant environment is started, you can easily list all the service URLs on the [Homepage dashboard](https://homepage.tool.k8s.test/).

### Kubernetes dashboard

An `admin-user` service account is automatically created by the playbook.

To login, you need to generate a token for this account.

You can do so using a terminal (assuming you start at the project root) :

```shell
[your_account@your_computer$] cd vagrant
[your_account@your_computer$] vagrant ssh master
[vagrant@master$] sudo su - user
[user@master$] kubectl --namespace=infra-kubernetes-dashboard create token dashboard-admin-user
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

User `user_ldap` has access to everything.
You can add a TOTP device for `user_ldap` and force its use by setting the `requiredAuthnLevel` property under each domain in `lemonldap_location_rules` in `ansible/inventories/vagrant/group_vars/all/apps/auth-lemonldap`

### phpLDAPadmin

You can login using the `cn=readonly,dc=k8s,dc=test` / `Passw0rd` or `cn=admin,dc=k8s,dc=test` / `Passw0rd` account to manage the LDAP.

### Crowdsec

Crowdsec is deployed, and configured with the default collections :

* crowdsecurity/linux
* crowdsecurity/sshd
* crowdsecurity/nginx

To test it in the Vagrant cluster, we can't just inject trafic from the local network : RFC1918 ranges are whitelisted by default.

We can however simulate logs.
For example, to simulate an SSH brute force attack:

```bash
echo "$(date '+%b %d %T') $(hostname) sshd[123456]: Connection closed by authenticating user root 1.2.3.4 port 12345 [preauth]" >> /var/log/auth.log
```

After a few lines added, crowdsec should ban the ip.

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

### Blocky

Blocky is configured :

* Upstreams to CloudFlare
* "standard" blocklists

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

### Ntfy

Ntfy can be used to send notifications.

A few users are configured :

* `admin_local` / `Passw0rd` can read and write all topics
* `user_local` / `Passw0rd` can read all topics
* `alertmanager` / `Passw0rd` can write on `alerts` and is used by alertmanager to push alerts
* `homeassistant` / `Passw0rd` can write on `home` and is used by homeassistant to push notifications

To send a sample message, you can use :

```bash
curl -u admin_local:Passw0rd -d "Test message" $(kubectl --namespace=infra-ntfy get service ntfy -o=jsonpath='{.spec.clusterIP}'):8080/test
```

### Prometheus & AlertManager

Prometheus & AlertManager are deployed, and configured to gather metrics from the usual exporters :

* [node_exporter](https://github.com/prometheus/node_exporter)
* [kube_state_metrics](https://github.com/kubernetes/kube-state-metrics)

Their deployment manifests and configurations are based on the examples provided by the contrib project [Kube Prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus)

### Grafana

Grafana is deployed and configured to use Prometheus as a data source.

Default Kubernetes dashboards are already created, based on [Kube Prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus).

You can use the default admin account : `admin_local` / `Passw0rd`.
Or the regular account : `user_ldap` / `Passw0rd`.

### Fluent Bit

Fluent Bit is deployed on all nodes to capture logs and forward them to ElasticSearch.

### ElasticSearch

The [OpenSearch](https://opensearch.org/) variant of ElasticSearch is deployed.

You can test the 'E' part of the EFK stack by calling : <https://elasticsearch.log.intra.k8s.test/_cluster/state?pretty>

You can use the exporter's user to test : `exporter` / `password`

### Kibana

The [OpenSearch Dashboards](https://opensearch.org/) variant of Kibana is deployed and configured to read data from ElasticSearch.

You can use the regular account : `user_ldap` / `Passw0rd`.

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

You can then use the regular account using `Logging in with Command Line Authentication`: `user_ldap` / `Passw0rd`.

The deployment also prepares and configures a MySQL database to use for HomeAssistant [recorder](https://www.home-assistant.io/components/recorder/).

### Z-Wave JS UI

Z-Wave JS UI is not automatically installed for Vagrant. It requires access to a ZWave serial device (most probably exposed on a TCP port via ser2net).

If configured and deployed, it can be accessed using `user_local` / `Passw0rd` on the web ui.

It can be added as an integration in Home Assistant using the following URL : `ws://zwavejsui.home-zwave-js-ui.svc.cluster.local:3000`.

### Zigbee2MQTT

Zigbee2MQTT is not automatically installed for Vagrant. It requires access to a Zigbee serial device (most probably exposed on a TCP port via ser2net).

If configured and deployed, it can be accessed using `user_local` / `Passw0rd` on the web ui.

### Frigate

Frigate is installed and a basic empty configuration is deployed.

You can add cameras by editing the configuration on master-test-1 : `/data/volumes/frigate-config/config/config.yml`

It can be [integrated with Home Assistant](https://blakeblackshear.github.io/frigate/usage/home-assistant).
When configuring the Frigate integration, use the URL : <http://frigate.home-frigate.svc.cluster.local:5000>

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

You can use the regular account : `user_ldap` / `Passw0rd`.

A sample flow is already deployed to show how Node-RED integrates with HomeAssistant.
It requires :

* generating a HomeAssistant long lived access token (from the HomeAssistant profile page)
* configuring the HomeAssistant Server on Nod-RED

The sample flow is commented to help these steps.

### Room Assistant

RoomAssistant is deployed and configured to use Mosquitto.

A sample Shell script is used to generate a random number and push it as a sensor on Home Assistant.

The real use case would be to use either a real shell, and/or enable the BLE plugin to detect room presence.

### Homepage

Homepage is installed.

Apps deployed in the cluster are added on the dashboard.

### Miniflux

Miniflux is installed.
You can use the local admin account : `admin_local` / `Passw0rd`.

### Nextcloud

Nextcloud is installed.

The default admin account is `admin_local` / `Passw0rd`.

LDAP authentication is configured and enabled.

Some additional apps are installed by default.
However, they need to be manually enabled from the [app list](https://nextcloud.tool.intra.k8s.test/index.php/settings/apps).

A custom Cronjob is also deployed to automatically reschedule tasks.
It runs daily, and can be manually triggered for a specific date using :

```bash
run_date=$(date +%Y%m%d)  # Or a fixed date using YYMMDD format
kubectl --namespace tool-nextcloud create job --from=cronjob/task-rescheduler task-rescheduler-manual --dry-run -o "json" \
  | jq ".spec.template.spec.containers[0].env += [{ \"name\": \"RUN_DATE\", value:\"${run_date}\" }]" \
  | kubectl apply -f -
```

### Parperless

Paperless-NGX is installed.

The default account is `admin_local` / `Passw0rd`.

### Syncthing

Syncthing is installed.

The default `user_ldap` account (from OpenLDAP) has access.

The data directory is set to the mock NAS.

To add another Syncthing client, configure its global discovery to : <https://syncthing-discovery.tool.intra.k8s.test/?insecure>

### Gitea

Gitea is installed and configured.

A default local admin account is created : `admin_local` / `Passw0rd`.
The default `user_ldap` account (from OpenLDAP) also has access.

### Jellyfin

Jellyfin is deployed and configured.
The default `user_ldap` account (from OpenLDAP) has admin access.

### Airsonic

Airsonic is deployed and configured to look for music on the NAS share by default.
You can use the regular account : `user_ldap` / `Passw0rd`.

### Sickchill

Sickchill is installed.

A default `user_local` / `Passw0rd` user is created.

Search providers are not configured by default.

The mock NAS storage is used as media storage.

### Deluge

Deluge is installed.

The mock NAS storage is used as media storage.

The webui uses the password : `Passw0rd`.

### pyload

pyLoad is installed.

The mock NAS storage is used as media storage.

A default `user_local` / `Passw0rd` user is created.

### SABnzbd

pyLoad is installed.

The mock NAS storage is used as media storage.

A default `user_local` / `Passw0rd` user is created.

[nzbToMedia](https://github.com/clinton-hall/nzbToMedia) is added and configured to notify Sickchill of finished downloads.

## Backups

The backup tools are deployed and configured on the Vagrant guests.

However, to keep it simple, each host uses a local restic repository saved `/tmp`.
