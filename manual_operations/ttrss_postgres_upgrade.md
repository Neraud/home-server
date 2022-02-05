
# Upgrade TT-RSS PostgreSQL

## Stop clients

```bash
kubectl --namespace web-ttrss scale statefulset ttrss-job --replicas=0
kubectl --namespace web-ttrss scale statefulset ttrss-web --replicas=0
```

## Dump database

```bash
kubectl --namespace web-ttrss exec -it ttrss-pgsql-0 -- /usr/local/bin/pg_dumpall -U ttrss --no-role-passwords > /tmp/ttrss_dump.sql
```

**Note** : `--no-role-passwords`, as we use ENV_VAR to pass the user and password to the container.

Dumping the password can also cause issues with the encryption used. For example from v13 (`password_encryption=md5` by default) to v14 (`password_encryption=scram-sha-256` by default)

## Stop db server

```bash
kubectl --namespace web-ttrss scale statefulset ttrss-pgsql --replicas=0
```

## Backup & wipe volume

```bash
./mount_gluster_volume.sh ttrss-pgsql
mv /data/volumes/ttrss-pgsql/data /tmp/ttrss-pgsql-data-old
```

## Upgrade

```bash
/opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-web-ttrss
```

## Restore DB

```bash
kubectl --namespace web-ttrss scale statefulset ttrss-pgsql --replicas=1
```

Wait for the DB to be started.

```bash
kubectl --namespace web-ttrss exec -it ttrss-pgsql-0 -- psql -U ttrss < /tmp/ttrss_dump.sql
```

## Restart clients

```bash
kubectl --namespace web-ttrss scale statefulset ttrss-job --replicas=1
kubectl --namespace web-ttrss scale statefulset ttrss-web --replicas=1
```
