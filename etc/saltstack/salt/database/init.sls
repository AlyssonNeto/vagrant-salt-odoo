postgresql:
  pkgrepo.managed:
    - name: deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc

  pkg.installed:
    - pkgs:
      - postgresql-9.3
      - postgresql-contrib-9.3
      - postgresql-client-9.3
      - postgresql-server-dev-9.3
      - postgresql
    - require:
      - pkgrepo: postgresql

  service.running:
    - enable: True
    - require:
      - pkg: postgresql
