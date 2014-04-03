{% set nn_host = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh4.hadoop.namenode', 'grains.items', 'compound').values()[0]['fqdn'] %}
#!/bin/bash -e

sudo -u hdfs hadoop fs -mkdir -p /user/{{pillar.cdh4.hive.user}}/warehouse
sudo -u hdfs hadoop fs -chmod a+rwx /user/{{pillar.cdh4.hive.user}}/warehouse
sudo -u hdfs hadoop fs -chmod a+rwx /tmp

# configure mysql
/usr/bin/mysql_secure_installation <<EOF

n
y
y
y
y
EOF


# create the metastore database
SETUPSQL="/tmp/hive_setup.sql"
cat >$SETUPSQL <<EOF
CREATE DATABASE metastore;
USE metastore;
SOURCE {{pillar.cdh4.hive.home}}/scripts/metastore/upgrade/mysql/hive-schema-0.10.0.mysql.sql;
CREATE USER '{{pillar.cdh4.hive.user}}'@'{{ nn_host }}' IDENTIFIED BY '{{pillar.cdh4.hive.metastore_password}}';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{pillar.cdh4.hive.user}}'@'{{ nn_host }}';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES,EXECUTE ON metastore.* TO '{{pillar.cdh4.hive.user}}'@'{{ nn_host }}';
FLUSH PRIVILEGES;
EOF

mysql -u root < $SETUPSQL

# cleanup
rm -f $SETUPSQL

