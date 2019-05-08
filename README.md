
# HomeServer Provisioning

This project contains the playbook to provision my home servers.

It creates a Kubernetes cluster on self hosted bare metal hosts and deploy apps.

It also contains a Vagrant environment to test the playbooks and services.

## Why selfhosted

Not taking into account personal bias about hosting in the cloud, I'm running 2 types of services that are not compatible with cloud providers :

1. Home automation :
   * I need access to physical devices (USB sticks)
   * I don't want to lose access to my automations if my internet connexion goes down
2. Media Streaming
    * The cost would be too high (storage + cpu to transcode)

Going the self-hosted route has a few [consequences on the infrastructure](docs/Bare_metal_considerations.md).

## Hosts

The underlying hardware is detailed on a [dedicated page](docs/Hardware_detail.md), but to keep it short :

| Type      | Cores | CPU Model                                                                                                                                |  RAM  | Storage   |
| --------- | :---: | ---------------------------------------------------------------------------------------------------------------------------------------- | :---: | --------- |
| Master    |  2/4  | [Intel i3-3217U](https://ark.intel.com/products/65697/Intel-Core-i3-3217U-Processor-3M-Cache-1-80-GHz-)                                  |  8G   | SSD 64G   |
| Node_1    |  2/4  | [Intel i5-6260U](https://ark.intel.com/products/91160/Intel-Core-i5-6260U-Processor-4M-Cache-up-to-2-90-GHz-)                            |  32G  | SSD 500G  |
| Node_2    |  4/8  | [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) |  32G  | SSD 500G  |
| Node_Home |  4/4  | [Intel Atom x5 Z8350](https://ark.intel.com/products/93361/Intel-Atom-x5-Z8350-Processor-2M-Cache-up-to-1-92-GHz-)                       |  2G   | Flash 32G |

## Vagrant

The Vagrantfile creates 3 *similar* guests :

| Type      | Cores |  RAM  | Storage |
| --------- | :---: | :---: | :-----: |
| Master    |   2   |  4G   |    -    |
| Node_1    |   4   |  8G   |   50G   |
| Node_Home |   2   |  2G   |   10G   |

These settings are configured in `Vagrantconfig.yaml`, feel free to change them or add mode nodes.

### NAS

To simulate a NAS, NFS Server is installed on Master and exports the content of `/opt/mock_nas` to other hosts as NFS shares.

## Test hosts

To test the deployed services, you will have to add the following domains to your hosts file :

```
192.168.100.10 k8stest.com
192.168.100.10 infra.k8stest.com
192.168.100.10 auth.k8stest.com
192.168.100.10 unifi.k8stest.com
192.168.100.10 home.k8stest.com
192.168.100.10 web.k8stest.com
192.168.100.10 dev.k8stest.com
192.168.100.10 stream.k8stest.com
192.168.100.10 plex.k8stest.com
192.168.100.10 dl.k8stest.com
```

### User

To avoid using `root` directly, a standard user is created. For the Vagrant environment, it's simply named `user`.

This `user` can

* `sudo` without password
* SSH to other machines without password (using RSA keys)
* use kubectl

### HTTPS

All HTTPS certificates are self-signed, so you'll need to accept a warning the first time you access a domain.

The playbook supports [Let's Encrypt](https://letsencrypt.org/) to generate valid certificates on a production environment.

### Credentials

Unless listed, all credentials are `user` / `Passw0rd`.

For more information, take a look at the [authentication and authorization page](docs/Authentication_authorization.md).

## Services

The folowing services are deployed :

| Service                                                          | Test URL                                | Description                                   |
| ---------------------------------------------------------------- | --------------------------------------- | --------------------------------------------- |
| [Kubernetes dashboard](https://github.com/kubernetes/dashboard/) | https://infra.k8stest.com/kube          | Kubernetes dashboard                          |
| [OpenLDAP](https://www.openldap.org/)                            | -                                       | Open source Lightweight Directory Access Protocol |
| [LemonDAP](https://lemonldap-ng.org/welcome/)                    | https://infra.k8stest.com/lemonldap/manager.html | Web Single Sign On and Access Management Free Software |
| [phpLDAPadmin](http://phpldapadmin.sourceforge.net/)             | https://infra.k8stest.com/phpldapadmin/ | Web-based LDAP browser                        |
| [ZoneMTA](https://github.com/zone-eu/zone-mta)                    | -                                      | Modern outbound SMTP relay                    |
| [MailHog](https://github.com/mailhog/MailHog)                    | https://infra.k8stest.com/mailhog/      | MailHog is an email testing tool for developers |
| [Prometheus](https://prometheus.io/)                             | https://infra.k8stest.com/prometheus/   | Monitoring solution                           |
| [AlertManager](https://github.com/prometheus/alertmanager)       | https://infra.k8stest.com/alertmanager/ | Alert manager for Prometheus                  |
| [Grafana](https://grafana.com/)                                  | https://infra.k8stest.com/grafana/      | Platform for beautiful analytics and monitoring  |
| [Fluent Bit](https://fluentbit.io/)                              | -                                       | Lightweight log Processor and Forwarder       |
| [FluentD](https://www.fluentd.org/)                              | -                                       | Log Processor and Forwarder                   |
| [ElasticSearch](https://www.elastic.co/products/elasticsearch)   | https://infra.k8stest.com/elastic       | Distributed, RESTful search and analytics engine |
| [Kibana](https://www.elastic.co/products/kibana)                 | https://infra.k8stest.com/kibana/       | Visualize your Elasticsearch data             |
| [Unifi Controller](https://unifi-sdn.ubnt.com/)                  | https://unifi.k8stest.com/              | Controller for Unifi devices                  |
| [HomeAssistant](https://www.home-assistant.io/)                  | https://home.k8stest.com/               | Home automation                               |
| [Node-RED](https://nodered.org/)                                 | https://home.k8stest.com/node-red/      | Flow-based programming for the IoT            |
| [Mosquitto](https://mosquitto.org/)                              | mqtts://home.k8stest.com                | MQTT broker                                   |
| [RoomAssistant](https://github.com/mKeRix/room-assistant)        | -                                       | Presence tracking                             |
| [TT-RSS](https://tt-rss.org/)                                    | https://web.k8stest.com/tt-rss/         | News feed (RSS/Atom) reader and aggregator    |
| [Gitlab](https://about.gitlab.com/)                              | https://dev.k8stest.com/gitlab/         | Source code management and CI/CD              |
| [Plex](https://www.plex.tv/)                                     | https://plex.k8stest.com/               | Video streaming                               |
| [Airsonic](https://airsonic.github.io/)                          | https://stream.k8stest.com/airsonic/    | Music streaming                               |
| [Sickchill](https://sickchill.github.io/)                        | https://dl.k8stest.com/sickchill/       | Automatic Video Library Manager for TV Shows. |
| [Deluge](https://deluge-torrent.org/)                            | https://dl.k8stest.com/deluge/          | Torrent client                                |
| [pyload](https://pyload.net/)                                    | https://dl.k8stest.com/pyload/          | HTTP download manager                         |
| [SABnzbd](https://sabnzbd.org/)                                  | https://dl.k8stest.com/sabnzbd/         | Binary newsreader                             |

### Kubernetes dashboard

An `admin-user` service account is automatically created by the playbook.

To login, you need to fetch the associated token.

You can do so using a terminal (assuming you start at the project root) :

```shell
[your_account@your_computer$] cd vagrant
[your_account@your_computer$] vagrant ssh master
[vagrant@master$] sudo su - user
[user@master$] kubectl --namespace=kube-system describe secrets $(kubectl --namespace=kube-system get secrets | awk '/admin-user-token/ { print $1 }')
```

### OpenLDAP

OpenLDAP is installed and configured for the base domain.
`admin` and `config` accounts are created with a default password `Passw0rd`.

It enforces TLS with a self-signed CA.
This `ca.crt` is available in the Kubernetes secret `cluster-ca`

To test the LDAP connection, you can use : 

```shell
[user@master$] kubectl run test-ldap -it --rm --image=particlekit/ldap-client --restart=Never --overrides='
{
    "spec": {
      "containers": [
        {
          "name": "test-ldap",
          "image": "particlekit/ldap-client",
          "args": [
            "ldapsearch", "-x", "-H", "ldaps://openldap.default", "-b", "dc=k8stest,dc=com", "-D", "cn=admin,dc=k8stest,dc=com", "-w", "Passw0rd"
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
You can add a TOTP device for `user` and force its use by setting the `requiredAuthnLevel` property under each domain in `lemonldap_location_rules` in `ansible/inventories/vagrant/group_vars/all/kubernetes-apps`

### phpLDAPadmin

You can login using the `admin`/`Passw0rd` account to manage the LDAP.

### ZoneMTA

ZoneMTA is used to collect all emails sent by applications on the platform and forward them to another MTA.
By default, it forwards to MailHog for debugging purposes. But it can be set up to forward to a proper MTA (using a gmail account for example)

You can easily test ZoneMTA by sending a email via the command line : 

```shell
[root@master$] apt-get -q -y install swaks libnet-ssleay-perl
 
[user@master$] echo "This is the message body" | swaks \
    --to "someone@example.com" --from "you@example.com" \
    --auth --auth-user=smtp --auth-password=Passw0rd \
    --server $(kubectl get service zonemta -o=jsonpath='{.spec.clusterIP}'):587
```

### MailHog

MailHog is used to capture all emails sent by the various deployed services.

Out of the box, it is only used for testing purposes : you can view those emails using a web interface.

You can easily test MailHog by sending a email via the command line : 

```shell
[root@master$] apt-get -q -y install swaks
 
[user@master$] echo "This is the message body" | swaks --to "someone@example.com" --from "you@example.com" --server $(kubectl get service mailhog -o=jsonpath='{.spec.clusterIP}'):1025
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

You can test the 'E' part of the EFK stack by calling : https://infra.k8stest.com/elasticsearch/_cluster/state?pretty

You can use the exporter's user to test : `exporter` / `password`

### Kibana

The [OpenDistro](https://opendistro.github.io/for-elasticsearch/) variant of Kibana is deployed and configured to read data from ElasticSearch.

Saved Objects (sources, visualizations, dashboards) are loaded from the `apps/logging/kibana/config` folder.

To add new objects, you can :

* configure them via the Kibana web application
* export them using the `kibana_sav_objects.py` script
* save the json files under the `apps/logging/kibana/config` folder

### Unifi Controller

The Unifi Controller is installed.

The Web GUI will be available using the standard ReverseProxy + Ingress chain.

However, the controller requires a few other non-http ports, which has 2 impacts on the settings : 

* the IP of the Node that hosts the Pod is configred in the variable `unifi_private_ip`
* these ports are exposed on a `unifi-private` service on this IP
* these ports are allowed in this node's firewall

When setting the controller up, the inform URL setting will need to be changed to : `http://[unifi_private_ip]:8080/inform`

### HomeAssistant

HomeAssistant will prompt for the 1st user creation.

The deployment also prepares and configures a MySQL database to use for HomeAssistant [recorder](https://www.home-assistant.io/components/recorder/).

### Mosquitto

The MQTT broker Mosquitto is deployed.

A Fake sensor is created in HomeAssistant, based on the topic `test/test_sensor`.

To push values on this sensor :

```shell
[user@master$] kubectl run test-mqtt-pub -it --rm --image=aksakalli/mqtt-client --restart=Never --overrides='
{
    "spec": {
      "containers": [
        {
          "name": "test-ldap",
          "image": "aksakalli/mqtt-client",
          "args": [
            "pub", "-h", "mosquitto.default", "-p", "8883", "--cafile", "/certs/ca.crt", "-u", "user", "-P", "Passw0rd", "-t", "test/test_sensor", "-m", "Mock Value"
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
[user@master$] kubectl run test-mqtt-sub -it --rm --image=aksakalli/mqtt-client --restart=Never --overrides='
{
    "spec": {
      "containers": [
        {
          "name": "test-ldap",
          "image": "aksakalli/mqtt-client",
          "args": [
            "sub", "-h", "mosquitto.default", "-p", "8883", "--cafile", "/certs/ca.crt", "-u", "user", "-P", "Passw0rd", "-t", "#"
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

### Gitlab

Gitlab is installed using the omnibus package.

The `root` account password is set the first time the site is displayed.
The default `user` account (from OpenLDAP) also has access.

### Plex

Plex Media Server is deployed.

However the configuration is a bit more complicated for this one.

First, you'll need a [Plex account](https://www.plex.tv/sign-up/).
If you already have one and just want to test this repo on Vagrant, I'd recommend to create a dedicated test account.

#### Using SSH tunnel (recommended)

Basically, we'll follow the [official documentation](https://github.com/plexinc/pms-docker#running-on-a-headless-server-with-container-using-host-networking)

The Master Vagrant guest already has a port forward for port 32400.

We only need to forward this port to the plex container :

```shell
root@master:~# ufw allow 32400
Rule added
Rule added (v6)

root@master:~# su - user

user@master:~$ kubectl port-forward plex-0 32400:32400 --address 0.0.0.0
Forwarding from 0.0.0.0:32400 -> 32400
```

Then use the [localhost URL](http://localhost:32400/web/) to access PMS and proceed with the setup process.
Once done, you can use it with the proper URL without any issue.

You can safely stop the port-forwarding and block the port again :

```shell
user@master:~$ exit
logout

root@master:~# ufw deny 32400
Rule updated
Rule updated (v6)
```

#### Using the Claim token

Using a special environment variable `PLEX_CLAIM` when the container start can automate this setup process.

It's easy to get the Plex Plaim manually (just hit the [claim URL](https://www.plex.tv/claim/)). However, it's only valid for 5 minutes.

To have a less time sensitive method, the playbook can fetch the claim automatically before starting the PMS container. 
But to do so, it needs your plex token.

To get your Plex Token :

* Go to your [Plex account](https://app.plex.tv/desktop#!/account)
* (Log in if prompted)
* Once the page is displayed, open the developer console in your browser (usually with the F12 key)
* Reload the page
* You should see around 50 requests captured in your browser, scroll up the list, look for a request that starts *user*, and click on it
* On the right panel, select the response tab and on the 2nd line look for the authToken property
* In ansible\inventories\vagrant\group_vars\all\kubernetes-apps, set this token in the variable `plex_plex_token`

### Airsonic

Airsonic is deployed and configured to look for music on the NAS share by default.

### Sickchill

Sickchill is installed.

Search providers are not configured by default.

The mock NAS storage is used as media storage.

### Deluge

Deluge is installed.

The mock NAS storage is used as media storage.

The webui uses the default password : `deluge`.

### pyload

pyLoad is installed.

The mock NAS storage is used as media storage.

A default `pyload` / `Passw0rd` user is created.

### SABnzbd

pyLoad is installed.

The mock NAS storage is used as media storage.

A default `sabnzbd` / `Passw0rd` user is created.

[nzbToMedia](https://github.com/clinton-hall/nzbToMedia) is added and configured to notify Sickchill of finished downloads.
