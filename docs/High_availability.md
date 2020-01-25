# High availability

To be clear, the cluster installed by this playbook isn't high available.

## Hardware

On the hardware side of things, at least 2 major points of failure remain :

* Single internet link
* Single power delivery (allviated by a UPS)

Also as it's a home setup, it's obviously not replicated accros multiple sites.

## Software stack

On the software stack side however, most of the components are configured to be "high-available ready".
By that I mean that the cluster I've built isn't sized to be HA, but it's "only" a matter of throwing more CPUs / RAM at it.

![Architecture - High availability](diagrams/Architecture_High_availability.png "Architecture - High availability")

### DNS

dnsmasq is used for local resolution.

It's installed on the 3 master nodes, and all nodes in the cluster are configured to used them.

**HighAvailability** : dnsmasq tolerates the loss of 2 master nodes

### Kubernetes

Kubernetes is installed using 3 master nodes, using the [stacked etcd topology](https://kubernetes.io/docs/setup/independent/ha-topology/#stacked-etcd-topology)

The apiserver is accessed though a HAProxy that distributes requests accross the 3 master nodes.

**HighAvailability** : Kubernetes tolerates the loss of 1 master node

### Storage

All persistent volumes use GlusterFS.

The GlusterFS volumes are built on 3 nodes with 2 replicas.
To lower the storage requirements, only 2 nodes hold data, with the 3rd one only being an arbiter.

**HighAvailability** : GlusterFS tolerates the loss of 1 master node

### Reverse Proxy

Keepalived is used to be sure we have an HA virtual IP.

On each master node, an NGinx instance is configured to access all the published services.

`master-1` is set as the default `master` node, with `master-2` and `master-3` as `backup`s.

**HighAvailability** : Reverse proxy tolerates the loss of 2 master nodes

There are 2 limitations with this setup :

#### SSL Cert

`master-1` is responsible for SSL cert renewal using certbot.

If it stays down for a long period, SSL certs will expire.

#### Load balancing

Trafic is not load balanced between the 3 NGinx instances.

It could easily be added. Howver, using a single active NGinx instance allows for a more effective fail2ban filtering.
If an IP tries to scan or brute force access to the cluster, fail2ban add an iptables rule to deny this IP. Using 3 hosts means that each instance will have its own fail2ban counters and its own iptables rules. It will allow for more tries before denying the IP.

## Applications

Finally on the applications side, it's a bit more hit-and-miss. But mostly miss.

Some can easily be scaled up to be HA (docker registry for example).

Others would be more complex to handle (MySQL, OpenLDAP ...).
