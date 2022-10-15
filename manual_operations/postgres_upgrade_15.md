
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
kubectl --namespace dev-gitea exec -it pgsql-0 -- /usr/local/bin/pg_dumpall -U gitea --no-role-passwords > /tmp/gitea_dump.sql
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

```bash
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-infra-blocky
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-tool-miniflux
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-dev-gitea
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-tool-paperless
```

## Restore DB

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=1
kubectl --namespace tool-miniflux scale statefulset pgsql --replicas=1
kubectl --namespace dev-gitea scale statefulset pgsql --replicas=1
kubectl --namespace tool-paperless scale statefulset pgsql --replicas=1
```

Wait for the DB to be started.

```bash
kubectl --namespace infra-blocky exec -it pgsql-0 -- psql -U blocky < /tmp/blocky_dump.sql
kubectl --namespace tool-miniflux exec -it pgsql-0 -- psql -U miniflux < /tmp/miniflux_dump.sql
kubectl --namespace dev-gitea exec -it pgsql-0 -- psql -U gitea < /tmp/gitea_dump.sql
kubectl --namespace tool-paperless exec -it pgsql-0 -- psql -U paperless < /tmp/paperless_dump.sql
```

## Restart clients

```bash
kubectl --namespace infra-blocky scale deployment blocky --replicas=1
kubectl --namespace tool-miniflux scale deployment miniflux --replicas=1
kubectl --namespace dev-gitea scale statefulset gitea --replicas=1
kubectl --namespace tool-paperless scale statefulset paperless --replicas=1
```
