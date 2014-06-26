{% if grains['os_family'] == 'Debian' %}

# Add the appropriate CDH4 repository. See http://archive.cloudera.com/cdh4
# for which distributions and versions are supported.
/etc/apt/sources.list.d/cloudera.list:
  file:
    - managed
    - name: /etc/apt/sources.list.d/cloudera.list
    - source: salt://cdh4/etc/apt/sources.list.d/cloudera.list.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja 
    - require:
      - file: add_policy_file

cdh4_gpg:
  cmd:
    - run
    - name: 'curl -s http://archive.cloudera.com/cdh4/ubuntu/{{ grains["lsb_distrib_codename"] }}/amd64/cdh/archive.key | apt-key add -'
    - unless: 'apt-key list | grep "Cloudera Apt Repository"'
    - require:
      - file: /etc/apt/sources.list.d/cloudera.list

cdh4_refresh_db:
  module:
    - run
    - name: pkg.refresh_db
    - require:
      - cmd: cdh4_gpg

# This is used on ubuntu so that services don't start 
add_policy_file:
  file:
    - managed
    - name: /usr/sbin/policy-rc.d
    - contents: exit 101
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

remove_policy_file:
  file:
    - absent
    - name: /usr/sbin/policy-rc.d
    - require:
      - file: add_policy_file

{% elif grains['os_family'] == 'RedHat' %}

# Set up the CDH4 yum repository
cloudera_cdh4:
  pkgrepo:
    - managed
    - humanname: "Cloudera's Distribution for Hadoop, Version 4"
    - baseurl: "http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/{{ pillar.cdh4.version }}/"
    - gpgkey: http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
    - gpgcheck: 1

cloudera_impala:
  pkgrepo:
    - managed
    - humanname: "Impala"
    - baseurl: http://archive.cloudera.com/impala/redhat/6/x86_64/impala/{{ pillar.cdh4.impala.version }}/
    - gpgkey: http://archive.cloudera.com/impala/redhat/6/x86_64/impala/RPM-GPG-KEY-cloudera
    - gpgcheck: 1

cdh4_gpg:
  cmd:
    - run
    - name: 'rpm --import http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera'
    - unless: 'rpm -qi gpg-pubkey-e8f86acd'
    - require:
      - pkgrepo: cloudera_cdh4

cdh4_refresh_db:
  module:
    - run
    - name: pkg.refresh_db
    - require:
      - cmd: cdh4_gpg

{% endif %}

