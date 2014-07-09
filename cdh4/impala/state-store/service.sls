
{% if grains['os_family'] == 'Debian' %}
extend:
  remove_policy_file:
    file:
      - require:
        - service: impala-state-store
        - service: impala-catalog
{% endif %}

# 
# Start impala processes
#

impala-state-store:
  service:
    - running
    - require:
      - pkg: impala-state-store-install
      - file: /etc/default/impala
      - file: /etc/default/bigtop-utils
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      {% if 'cdh4.hbase.master' in grains['roles'] or 'cdh4.hbase.regionserver' in grains['roles'] %}
      - file: /etc/impala/conf/hbase-site.xml
      {% endif %}

impala-catalog:
  service:
    - running
    - require:
      - pkg: impala-state-store-install
      - service: impala-state-store
      - file: /etc/default/impala
      - file: /etc/default/bigtop-utils
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      {% if 'cdh4.hbase.master' in grains['roles'] or 'cdh4.hbase.regionserver' in grains['roles'] %}
      - file: /etc/impala/conf/hbase-site.xml
      {% endif %}
