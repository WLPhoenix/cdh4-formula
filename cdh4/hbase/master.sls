include:
  - cdh4.repo
  - cdh4.hadoop.client
  - cdh4.hbase.regionserver_hostnames
  - cdh4.zookeeper
  - cdh4.hbase.conf

extend:
  /etc/hbase/conf/hbase-site.xml:
    file:
      - require:
        - pkg: hbase-master
  /etc/hbase/conf/hbase-env.sh:
    file:
      - require:
        - pkg: hbase-master
{% if grains['os_family'] == 'Debian' %}
  remove_policy_file:
    file:
      - require:
        - service: hbase-master
{% endif %}


hbase-init:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hadoop fs -mkdir /hbase && hadoop fs -chown hbase:hbase /hbase'
    - unless: 'hadoop fs -test -d /hbase'
    - require:
      - pkg: hadoop-client

hbase-master:
  pkg:
    - installed 
    - require:
      - cmd: hbase-init
      - service: zookeeper-server
      - file: append_regionservers_etc_hosts
  service:
    - running
    - require: 
      - pkg: hbase-master
      - file: /etc/hbase/conf/hbase-site.xml
      - file: /etc/hbase/conf/hbase-env.sh
    - watch:
      - file: /etc/hbase/conf/hbase-site.xml
      - file: /etc/hbase/conf/hbase-env.sh

