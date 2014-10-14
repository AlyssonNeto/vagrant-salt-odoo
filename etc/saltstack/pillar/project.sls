# vim: sts=2 ts=2 sw=2 et ai
users:
  vagrant:
    full_name: Vagrant user
    sudoer: True
    home: /home/vagrant
    groups: ['odoo', 'www-data']
    database_user_name: vagrant
    database_pasword: db_pwd

projects:
  myproject:
    name: myproject
    buildout_path: /vagrant/myproject_buildout
    user: vagrant
    database_name: myproject
    database_password: db_pwd
    repository: http://www.github.com/user/project # not used yet
    branch: master
    fqdn: 'myproject.vagrant'
    alias: ['www.myproject.vagrant']
    certificate_type: autosign # autosign | legacy (not implemented yet) | None 
    xmlrpc_port: 8069
    longpolling_port: 8169
    virtual_display: 1
