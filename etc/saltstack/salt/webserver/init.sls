# vim: sts=2 ts=2 sw=2 et ai

nginx:
  pkg.installed:
    - name: nginx
  service:
    - running
    - enable: True
    - restart: True

ssl-cert:
  pkg.installed:
    - name: ssl-cert

nginx-group:
  group.present:
    - name: www-data

ssl-cert-group:
  group.present:
  - name: ssl-cert

nginx-user:
  user.present:
    - name: nginx
    - groups:
      - www-data
      - ssl-cert
      
/etc/nginx/ssl:
  file.directory:
    - user: root
    - group: root
    - mode: 0700

