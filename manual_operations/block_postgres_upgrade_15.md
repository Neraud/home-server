
# Upgrade Blocky PostgreSQL

## Stop clients

```bash
kubectl --namespace infra-blocky scale deployment blocky --replicas=0
```

## Dump database

```bash
kubectl --namespace infra-blocky exec -it pgsql-0 -- /usr/local/bin/pg_dumpall -U blocky --no-role-passwords > /tmp/blocky_dump.sql
```

**Note** : `--no-role-passwords`, as we use ENV_VAR to pass the user and password to the container.

Dumping the password can also cause issues with the encryption used. For example from v13 (`password_encryption=md5` by default) to v14 (`password_encryption=scram-sha-256` by default)

## Stop db server

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=0
```

## Backup & wipe volume

```bash
./mount_gluster_volume.sh blocky-pgsql
mv /data/volumes/blocky-pgsql/data /tmp/blocky-pgsql-data-old
```

## Upgrade

```bash
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-infra-blocky
```

## Restore DB

```bash
kubectl --namespace infra-blocky scale statefulset pgsql --replicas=1
```

Wait for the DB to be started.

```bash
kubectl --namespace infra-blocky exec -it pgsql-0 -- psql -U blocky < /tmp/blocky_dump.sql
```

## Restart clients

```bash
kubectl --namespace infra-blocky scale deployment blocky --replicas=1
```
