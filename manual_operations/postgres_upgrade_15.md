
# Upgrade PostgreSQL 14 to 15

## Stop clients

```bash
kubectl --namespace infra-blocky scale deployment blocky --replicas=0
kubectl --namespace tool-miniflux scale deployment miniflux --replicas=0
kubectl --namespace dev-gitea scale statefulset gitea --replicas=0
kubectl --namespace tool-paperless scale statefulset paperless --replicas=0
```

## Dump database

```bash
kubectl --namespace infra-blocky exec -it pgsql-0 -- /usr/local/bin/pg_dumpall -U blocky --no-role-passwords > /tmp/blocky_dump.sql
kubectl --namespace tool-miniflux exec -it pgsql-0 -- /usr/local/bin/pg_dumpall -U miniflux --no-role-passwords > /tmp/miniflux_dump.sql
kubectl --namespace dev-gitea exec -it pgsql-0 -- /usr/local/bin/pg_dumpall -U gitea --no-role-passwords> /tmp/gitea_dump.sql
kubectl --namespace tool-paperless exec -it pgsql-0 -- /usr/local/bin/pg_dumpall -U paperless --no-role-passwords > /tmp/paperless_dump.sql
```

**Note** : `--no-role-passwords`, as we use ENV_VAR to pass the user and password to the container.

Dumping the password can also cause issues with the encryption used. For example from v13 (`password_encryption=md5` by default) to v14 (`password_encryption=scram-sha-256` by default)

## Stop db server

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=0
kubectl --namespace tool-miniflux scale statefulset pgsql --replicas=0
kubectl --namespace dev-gitea scale statefulset pgsql --replicas=0
kubectl --namespace tool-paperless scale statefulset pgsql --replicas=0
```

## Backup & wipe volume

```bash
./mount_gluster_volume.sh blocky-pgsql
mv /data/volumes/blocky-pgsql/data /tmp/blocky-pgsql-data-old

./mount_gluster_volume.sh miniflux-pgsql
mv /data/volumes/miniflux-pgsql/data /tmp/miniflux-pgsql-data-old

./mount_gluster_volume.sh gitea-pgsql
mv /data/volumes/gitea-pgsql/data /tmp/gitea-pgsql-data-old

./mount_gluster_volume.sh paperless-pgsql
mv /data/volumes/paperless-pgsql/data /tmp/paperless-pgsql-data-old
```

## Upgrade

### Add Local data Volume

Using a Glusterfs volume causes random `unexpected data beyond EOF` errors during the import.

1. Create the folder

```bash
mkdir -p /data/volumes/blocky-pgsql-temp/data
chown -R 70:70 /data/volumes/blocky-pgsql-temp/data

mkdir -p /data/volumes/miniflux-pgsql-temp/data
chown -R 70:70 /data/volumes/miniflux-pgsql-temp/data

mkdir -p /data/volumes/gitea-pgsql-temp/data
chown -R 70:70 /data/volumes/gitea-pgsql-temp/data

mkdir -p /data/volumes/paperless-pgsql-temp/data
chown -R 70:70 /data/volumes/paperless-pgsql-temp/data
```

2. Move the PVC on a different path.
3. Mount a hostPath volume on `/var/lib/postgresql/data`
4. Lock the container on the host you have mounted the Gluster volume

```yaml
        volumeMounts:
        - name: pgsql-pv-claim
          mountPath: /var/lib/postgresql/data_pvc
          subPath: data
        - name: data-volume
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: data-volume
        hostPath:
          path: /data/volumes/name-pgsql-temp/data
      nodeSelector:
        kubernetes.io/hostname: 'master-1'
```

### Apply

```bash
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-infra-blocky
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-tool-miniflux
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-dev-gitea
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-tool-paperless
```

### Scale up

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=1
kubectl --namespace tool-miniflux scale statefulset pgsql --replicas=1
kubectl --namespace dev-gitea scale statefulset pgsql --replicas=1
kubectl --namespace tool-paperless scale statefulset pgsql --replicas=1
```

## Restore

### Restore the dump

Wait for the DB to be started.

```bash
kubectl --namespace infra-blocky exec -it pgsql-0 -- psql -U blocky < /tmp/blocky_dump.sql
kubectl --namespace tool-miniflux exec -it pgsql-0 -- psql -U miniflux < /tmp/miniflux_dump.sql
kubectl --namespace dev-gitea exec -it pgsql-0 -- psql -U gitea < /tmp/gitea_dump.sql
kubectl --namespace tool-paperless exec -it pgsql-0 -- psql -U paperless < /tmp/paperless_dump.sql
```

### Scale down

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=0
kubectl --namespace tool-miniflux scale statefulset pgsql --replicas=0
kubectl --namespace dev-gitea scale statefulset pgsql --replicas=0
kubectl --namespace tool-paperless scale statefulset pgsql --replicas=0
```

### Move the files to the PVC volume

```bash
mv /data/volumes/blocky-pgsql-temp/data/* /data/volumes/blocky-pgsql/data/
mv /data/volumes/miniflux-pgsql-temp/data/* /data/volumes/miniflux-pgsql/data/
mv /data/volumes/gitea-pgsql-temp/data/* /data/volumes/gitea-pgsql/data/
mv /data/volumes/paperless-pgsql-temp/data/* /data/volumes/paperless-pgsql/data/
```

### Remove Local data Volume

```bash
rm -Rf /data/volumes/blocky-pgsql-temp
rm -Rf /data/volumes/miniflux-pgsql-temp
rm -Rf /data/volumes/gitea-pgsql-temp
rm -Rf /data/volumes/paperless-pgsql-temp
```

Restore the statefulset manifest.

## Restart

### Scale up

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=1
kubectl --namespace tool-miniflux scale statefulset pgsql --replicas=1
kubectl --namespace dev-gitea scale statefulset pgsql --replicas=1
kubectl --namespace tool-paperless scale statefulset pgsql --replicas=1
```

### Restart clients

```bash
kubectl --namespace infra-blocky scale deployment blocky --replicas=2
kubectl --namespace tool-miniflux scale deployment miniflux --replicas=1
kubectl --namespace dev-gitea scale statefulset gitea --replicas=1
kubectl --namespace tool-paperless scale statefulset paperless --replicas=1
```
