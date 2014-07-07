
{% if grains['os_family'] == 'Debian' %}
extend:
  remove_policy_file:
    file:
      - require:
        - service: impala-server
{% endif %}

# 
# Start impala processes
#

impala-server:
  service:
    - running
    - require:
      - pkg: impala
      - file: /etc/default/impala
      - file: /etc/default/bigtop-utils
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      {% if 'cdh4.hbase.master' in grains['roles'] or 'cdh4.hbase.regionserver' in grains['roles'] %}
      - file: /etc/impala/conf/hbase-site.xml
      {% endif %}
