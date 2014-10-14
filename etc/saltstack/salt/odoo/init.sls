# vim: sts=2 ts=2 sw=2 et ai
odoo_group:
  group.present:
    - name: odoo

odoo_anybox_apt:
  pkgrepo.managed:
    - humanname: Anybox Openerp 
    - name: deb http://apt.anybox.fr/openerp common main
    - keyid: "0xE38CEB07"
    - keyserver: hkp://subkeys.pgp.net
    - require_in:
        - pkg: openerp-server-system-build-deps
  pkg.latest:
    - name: openerp-server-system-build-deps
    - refresh: True

wkhtmltopdf:
  pkg.installed

python-virtualenv:
  pkg.installed

xvfb:
  pkg.installed
