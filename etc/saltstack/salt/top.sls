#: vim: sts=2 ts=2 sw=2 et ai
base:
  '*':
  
    # packages installation
    - common.init
    - odoo.init
    - webserver.init
    - database.init
    - services.init
    
    # setup odoo project
    - project.init
    
    # launch services
    - services.reload
    - webserver.reload
