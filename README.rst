Vagrant Salt Odoo
=================

-----
TLDR;
-----

Install virtualbox, vagrant, vagrant-hostupdater

    sudo apt-get install virtualbox vagrant && vagrant plugin install vagrant-hostsupdater

Clone this repository

    git clone https://github.com/franckbret/vagrant_salt_odoo.git myodooserver

Inside it clone a sample buildout for Odoo v8

    cd myodooserver
    git clone https://github.com/franckbret/odoo_buildout_starterkit.git myproject_buildout

Run 

    vagrant up

Make a coffee, take 5 minutes to read this doc, go to your favorite browser and enjoy `Odoo <https://www.odoo.com>`_ !

`<https://myproject.vagrant>`_

Default credentials are admin:admin

---------
Main Goal
---------

Run with ease an Odoo 8 project within a local Virtualbox (debian Vm)
    .
* `odoo-ready` Debian 7 server, shareable and reproductible
* Bootstrap project through recipes
* Tools to ease odoo management and development
* Module and project configuration files edition directly from host 

This project takes advantages of :

* `Saltstack <https://docs.saltstack.com/>`_ for provisioning the Vm
* `Anybox openerp-server-system-build-deps <http://apt.anybox.fr/openerp/dists/common/main/binary-arm/Packages/>`_ package, to install Odoo dependencies
* `Anybox buildout recipe <http://docs.anybox.fr/anybox.recipe.openerp/stable/>`_ to install and manage an Odoo project

I use it for demo, testing and Odoo development.

------------
Dependencies
------------

I run this setup on Ubuntu 14.04. Main level is Virtualbox, so it should works fine on any Host OS.
The guest is Debian 7.6.

Virtualbox
----------

    sudo apt-get install virtualbox

Vagrant
-------

    sudo apt-get install vagrant

Vagrant host updater plugin
---------------------------

This plugin automatically add and remove hosts entries in order to easily access the guest from host browser through a domain name.
This plugin is not mandatory. If you don't want to install it, just remove the `app.vm.hostname` entry from Vagrantfile.

    vagrant plugin install vagrant-hostsupdater

-------------
Configuration
-------------

Before launching it you should adjust some settings on several files.

VagrantFile
-----------

The VagrantFile defines how your Virtualbox will be build.

config.vm.box_url
-----------------

Default is a Debian 7.6 Virtualbox I've build. I'm french so the locales are french.
You can obviously use another box url that better suits your needs. See http://www.vagrantbox.es to find one.


config.vm.synced_folder
------------------------

Those settings define which local folder from host will be mounted on guest.
You should change the first one according to you project directory name.


app.vm.hostname
----------------

If you've installed the vagrant plugin `vagrant-hostupdater` this setting will add an entry to you hosts file so you can get access to the odoo instance through an fqdn.

Set what you need here, default is `myproject.vagrant`

app.vm.network :private_network, ip
------------------------------------

Set a private local ip for this box.

app.vm.network :public_network, ip
------------------------------------

I use it to test access with my phone or other computers from local network area.
Vagrant is unsecure by default, so remove this line if you don't need such kind of access.

salt.minion_config
-------------------

Salt is used for provisioning the vm. This setting defines the path of the minion config file.
The main reason for this is to tell salt to run masterless.
You can rename the minion file, just be sure to set the same path in salt.minion_config setting.

etc/saltstack/pillar/project.sls
---------------------------------

Pillar are used to define project variables. Change any value to suit your needs.
Just be sure to always have `vagrant` as user value.

First run
==========

Within a terminal change directory to your project, at the same level as the VagrantFile, and run 

    vagrant up

On first run, vagrant will provision the mahcine. It could take some time, depending on your host and internet connection bandwidth.
Usually it's about 2 minutes for me to build the vm, 10 minutes to grab the whole Odoo repository and run the buildout.

Closing the vm
==============

Vagrant halt will shutdown gracefully the vm.

    vagrant halt

Connecting the vm through ssh
=============================

You can connect the vm at anytime once it's launched by typing

    vagrant ssh

You'll be logged as the `vagrant` user. The `vagrant` user is also a passwordless sudoer, so you can run easily administrative tasks.


Provisioning
============

Normally at the first `vagrant up` command launch it should automatically provision the vm.

Sometimes hangs can occur cause some packages or external ressources are unreachables. Be sure your vm can connect the internets..
Please also note that cloning the Odoo repository is quite long, (+/- 300mb)

If for any reasons you need to relaunch the provisioning steps, run

    vagrant provision

If it's still not a success and/or you want a more verbose output, connect through ssh

    vagrant ssh

And tail the salt logs in order to see what's going on

    sudo tail -f /var/log/salt/minion

If you're still stuck and it takes an abnormal amount of time on the same step, just stop it and relaunch provisioning from host with `vagrant provision` command.

Alternatively you can also manually run the salt provisioning command from guest with

    sudo salt-call state.highstate -l debug

Accessing your Odoo project
===========================

On the host run a browser and point it to the url defined within the `app.vm.hostname` setting of your VagrantFile.
Default is `<https://myproject.vagrant>`_

Note that all traffic is redirected to https by default. You must accept the certificate to use it.

Useful commands
===============

Connect the Vm through ssh (before running any command)

    vagrant ssh

Reload supervisor (restart odoo process)

    sudo salt-call state.sls services.reload

Reload nginx

    sudo salt-call state.sls webserver.reload

Upgrade the whole webserver

    sudo salt-call state.highstate

Look at the salt files in etc/saltstack to views available salt states and add yours.

