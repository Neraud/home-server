# MysQL Upgrade to 8.4 and 9

## Allowed upgrades

To upgrade to MySQL 9, the database must use version 8.4. 8.0 to 9 is not possible.

## mysql_native_password deprecation

`mysql_native_password` plugin is deprecated in 8.0, disabled in 8.4 and removed in 9.

Without actions, clients will not be able to connect to 8.4 / 9 databases.

See <https://php.watch/articles/fix-php-mysql-84-mysql_native_password-not-loaded>

### If database is already upgraded to 8.4

Change the statefulset manifest to allow `mysql_native_password`:

```yaml
      containers:
      - name: mysql
        image: "mysql:8.4.4-oraclelinux9"
        args: ["--mysql-native-password=ON"]
```

Then proceed with the password update.

Remember to remove the args afterwards.

### Password update

Exec on the MySQL container and login as root

```bash
mysql -u root -p
```

List impacted users:

```sql
SELECT user, host, plugin from mysql.user WHERE plugin='mysql_native_password';
```

Fix each user:

```sql
ALTER USER '<user>'@'<host>' IDENTIFIED WITH caching_sha2_password BY 'plain_text_password';
```
