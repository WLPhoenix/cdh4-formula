# 
# Start the Hue service
#

{% if grains['os_family'] == 'Debian' %}
extend:
  remove_policy_file:
    file:
      - require:
        - service: hue-svc
{% endif %}

hue-svc:
  service:
    - running
    - name: hue
    - require:
      - pkg: hue
      - file: /mnt/tmp/hadoop
      - file: /etc/hue/hue.ini

/etc/hue/hue.ini:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hue/hue.ini
    - mode: 755


