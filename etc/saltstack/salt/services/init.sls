# vim: sts=2 ts=2 sw=2 et ai

supervisor-install:
  pkg:
    - name: supervisor
    - installed
    - user: root
  service:
    - name: supervisor
    - running

/etc/supervisor/conf.d:
  file.directory:
    - user: root
    - mode: 0755

/var/log/supervisor:
  file.directory:
    - user: root
    - mode: 0755

/etc/supervisord.conf:
  file.managed:
    - source: salt://services/supervisor-main.conf
    - user: root
    - group: root
    - mode: 0644

