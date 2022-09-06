
# HomeServer Provisioning

This project contains the playbook to provision my home servers.

It creates a Kubernetes cluster on self hosted bare metal hosts and deploy apps.

It also contains a Vagrant environment to test the playbooks and services.

## Why self-hosted

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
| master-1  |  2/4  | [Intel i5-6260U](https://ark.intel.com/products/91160/Intel-Core-i5-6260U-Processor-4M-Cache-up-to-2-90-GHz-)                            |  32G  | SSD 500G  |
| master-2  |  4/8  | [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) |  32G  | SSD 500G  |
| master-3  |  4/8  | [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) |  32G  | SSD 500G  |
| node-home |  4/4  | [Intel Atom x5 Z8350](https://ark.intel.com/products/93361/Intel-Atom-x5-Z8350-Processor-2M-Cache-up-to-1-92-GHz-)                       |  2G   | Flash 32G |
| node-1    | 8/16  | [AMD Ryzen 7 5700G](https://www.amd.com/en/products/apu/amd-ryzen-7-5700g)                                                               |  32G  | SSD 1T    |

## High availability

More information on the [dedicated page](docs/High_availability.md).

Spoiler : it's not really HA.

## Vagrant

To test this cluster, take a look at the [Vagrant page](docs/Vagrant.md).

## Services

The following services are deployed :

| Service                                                          | Description                                                     |
| ---------------------------------------------------------------- | --------------------------------------------------------------- |
| [Kubernetes dashboard](https://github.com/kubernetes/dashboard/) | Kubernetes dashboard                                            |
| [OpenLDAP](https://www.openldap.org/)                            | Open source Lightweight Directory Access Protocol               |
| [LemonDAP](https://lemonldap-ng.org/welcome/)                    | Web Single Sign On and Access Management Free Software          |
| [phpLDAPadmin](http://phpldapadmin.sourceforge.net/)             | Web-based LDAP browser                                          |
| [ZoneMTA](https://github.com/zone-eu/zone-mta)                   | Modern outbound SMTP relay                                      |
| [MailHog](https://github.com/mailhog/MailHog)                    | MailHog is an email testing tool for developers                 |
| [Blocky](https://0xerr0r.github.io/blocky/)                      | DNS proxy and ad-blocker for the local network                  |
| [Gotify](https://github.com/gotify/server)                       | Server for sending and receiving messages                       |
| [Prometheus](https://prometheus.io/)                             | Monitoring solution                                             |
| [AlertManager](https://github.com/prometheus/alertmanager)       | Alert manager for Prometheus                                    |
| [Grafana](https://grafana.com/)                                  | Platform for beautiful analytics and monitoring                 |
| [Fluent Bit](https://fluentbit.io/)                              | Lightweight log Processor and Forwarder                         |
| [FluentD](https://www.fluentd.org/)                              | Log Processor and Forwarder                                     |
| [OpenSearch](https://opensearch.org/)                            | Distributed, RESTful search and analytics engine                |
| [OpenSearch Dashboard](https://opensearch.org/)                  | Visualize your Elasticsearch data                               |
| [Unifi Controller](https://unifi-sdn.ubnt.com/)                  | Controller for Unifi devices                                    |
| [HomeAssistant](https://www.home-assistant.io/)                  | Home automation                                                 |
| [ESPHome](https://esphome.io/index.html)                         | System to control your ESP8266/ESP32                            |
| [Zwavejs2Mqtt](https://zwave-js.github.io/zwavejs2mqtt/)         | Fully configurable Zwave Gateway and Control Panel              |
| [Frigate](https://blakeblackshear.github.io/frigate/)            | Local NVR designed for Home Assistant with AI object detection  |
| [Node-RED](https://nodered.org/)                                 | Flow-based programming for the IoT                              |
| [Mosquitto](https://mosquitto.org/)                              | MQTT broker                                                     |
| [RoomAssistant](https://github.com/mKeRix/room-assistant)        | Presence tracking                                               |
| [TT-RSS](https://tt-rss.org/)                                    | News feed (RSS/Atom) reader and aggregator                      |
| [Homer](https://github.com/bastienwirtz/homer)                   | A very simple static homepage for your server                   |
| [Miniflux](https://miniflux.app/)                                | Miniflux is a minimalist and opinionated feed reader            |
| [Nextcloud](https://nextcloud.com/)                              | The self-hosted productivity platform that keeps you in control |
| [PaperlessNGX](https://github.com/paperless-ngx/paperless-ngx)   | Scan & OCR documents                                            |
| [OliveTin](https://docs.olivetin.app/)                           | Access to predefined shell commands from a web interface.       |
| [Syncthing](https://syncthing.net/)                              | Continuous file synchronization                                 |
| [Jellyfin](https://jellyfin.org/)                                | Video streaming                                                 |
| [Airsonic](https://airsonic.github.io/)                          | Music streaming                                                 |
| [Sickchill](https://sickchill.github.io/)                        | Automatic Video Library Manager for TV Shows.                   |
| [Deluge](https://deluge-torrent.org/)                            | Torrent client                                                  |
| [pyload](https://pyload.net/)                                    | HTTP download manager                                           |
| [SABnzbd](https://sabnzbd.org/)                                  | Binary newsreader                                               |

## Backups

Different tools are deployed to handle [backing the cluster up](docs/Backups.md).
Mainly, [restic](https://restic.net/) backs up critical data (host, app, nas), and then [Rclone](https://rclone.org/) copies the restic repositories off site (second Nas and GCS)
