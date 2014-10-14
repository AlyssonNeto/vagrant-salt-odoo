# vim: sts=2 ts=2 sw=2 et ai

nginx-watch:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch: 
      - file: /etc/nginx/sites-enabled/*

### USERS
{% for name, user in pillar['users'].iteritems() %}

# user
{{ name }}:
  user.present:
    - name: {{ name }}
    - home: {{ user.home }}
    - gid_from_name: True
    - shell: /bin/bash
    - groups:
{% for group in user.groups %}
      - {{ group }}
{% endfor %}
    - fullname: {{ user.full_name }}

#postgres user
postgres_user_{{ name }}:
  postgres_user.present:
    - name: {{ name }}
    - createdb: True

{% endfor %}

### PROJECTS
{% for name, project in pillar['projects'].iteritems() %}

# TODO
# directories
#{{ project.buildout_path }}:
#  file.directory:
#    - user: {{ project.user }}
#    - group: www-data
#    - mode: 0755
#    - makedirs: True

# databases
database_{{ project.database_name }}:
  postgres_database.present:
    - name: {{ project.database_name }}
    - user: {{ project.user }}
    - owner: {{ project.user }}
    - template: template0
    - encoding: UTF8
    - lc_ctype: fr_FR.UTF8
    - lc_collate: fr_FR.UTF8
    
# certificates
# TODO : manage others cases than autosign
{% if project.certificate_type and project.certificate_type == 'autosign' %}

install_autosigned_certificate_{{name}}:
  cmd.run:
    - name: openssl req -new -nodes -x509 -subj "/C=FR/ST=Ile de France/L=Paris/O=IT/CN={{project.fqdn}}" -days 3650 -keyout /etc/nginx/ssl/{{name}}.server.key -out /etc/nginx/ssl/{{name}}.server.crt -extensions v3_ca 
    - stateful: True
    - unless: test -s /etc/nginx/ssl/{{name}}.server.key

{% endif %}

# nginx vhost
/etc/nginx/sites-available/{{ project.fqdn }}.vhost.conf:
  file.managed:
    - source: salt://webserver/nginx-vhost-odoo.conf
    - user: {{ project.user }}
    - group: www-data
    - mode: 0644
    - template: jinja
    - context:
      project: {{project}}

# nginx symlink vhost
/etc/nginx/sites-enabled/{{ project.fqdn }}.vhost.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ project.fqdn }}.vhost.conf

# bootstrap the buildout
bootstrap_{{ project.name }}:
  cmd.run:
    - name : python bootstrap.py 
    - cwd : {{ project.buildout_path }}
    - user: {{ project.user }}
    - unless: test -s {{ project.buildout_path }}/bin/start_odoo

# run the buildout
buildout_{{ project.name }}:
  cmd.run:
    - name: ./bin/buildout -c buildout.cfg
    - cwd : {{ project.buildout_path }}
    - user: {{ project.user }}
    - unless: test -s {{ project.buildout_path }}/bin/start_odoo

# init odoo database
odoo_init_{{ project.database_name }}:
  cmd.run:
    - name: ./bin/upgrade_odoo -d {{ project.database_name }}
    - cwd : {{ project.buildout_path }}
    - user: {{ project.user }}
    - unless: test -s {{ project.buildout_path }}/bin/start_odoo

# add supervisor project conf
/etc/supervisor/conf.d/{{ project.name }}.supervisor.conf:
  file.managed:
    - source: salt://services/supervisor-odoo.conf
    - template: jinja
    - context:
      project: {{ project }}

{% endfor %}
