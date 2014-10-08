Vagrant Salt Odoo
=================

Run with ease an Odoo project within a local Virtualbox

-----
TLDR;
-----

Install virtualbox, vagrant, vagrant-hostupdater

    sudo apt-get install virtualbox vagrant && vagrant plugin install vagrant-hostsupdater

Clone this repository

    git clone https://github.com/franckbret/vagrant-salt-odoo.git myodooserver

Inside it clone a sample buildout for Odoo v8

    cd myodooserver

    git clone https://github.com/franckbret/odoo-starterkit.git myproject_buildout

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

* `Virtualbox <https://www.virtualbox.org/>`_ and `Vagrant <http://www.vagrantup.com/>`_ to provide a production like environement
* `Saltstack <https://docs.saltstack.com/>`_ for provisioning the Vm
* `Anybox openerp-server-system-build-deps <http://apt.anybox.fr/openerp/dists/common/main/binary-arm/Packages/>`_ package, to install Odoo dependencies
* `Anybox buildout recipe <http://docs.anybox.fr/anybox.recipe.openerp/stable/>`_ to install and manage an Odoo project

I use it for demo, testing and Odoo development.

-----------------
Host installation
-----------------

It's virtualbox, it should works fine on any Host OS.

Virtualbox
----------

Ubuntu / Debian

    sudo apt-get install virtualbox

Vagrant
-------

Ubuntu / Debian

    sudo apt-get install vagrant

Vagrant host updater plugin
---------------------------

This plugin automatically add and remove hosts entries in order to easily access the guest from host browser through a domain name.
This plugin is not mandatory. If you don't want to install it, just remove the `app.vm.hostname` entry from Vagrantfile.

    vagrant plugin install vagrant-hostsupdater

Create a new server project
---------------------------

Clone this repository. It will contains configuration files for server. 
There you will define several domain name to serve and local directories to mount.

    git clone https://github.com/franckbret/vagrant-salt-odoo.git myodooserver

Then enter new directory

    cd myodooserver

Create a new project
--------------------

Clone a sample buildout for Odoo. There you will set your project configuration file through a `buildout.cfg` file.

    git clone https://github.com/franckbret/odoo-starterkit.git myproject_buildout

--------------------
Guest Configuration
--------------------

Before launching anything you should adjust some settings on several files.

VagrantFile
-----------

The `VagrantFile <Vagrantfile>`_ defines how your Virtualbox will be build.
Here are some settings, find more about Vagrant and Salt provisioning here. `<https://docs.vagrantup.com/v2/provisioning/salt.html>`_


config.vm.box_url
-----------------

Default is a Debian 7.6 Virtualbox I've build. I'm french so the locales are french.
You can obviously use another box url that better suits your needs. See http://www.vagrantbox.es to find one.

You can also set a local path to a box image you've previously downloaded to avoid downloading a new image each time you make a new box.

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

---------------------
Project Configuration
---------------------

The project pillar
-------------------

Project level configuration variables can be set to suit your needs.
See `Pillar project file <etc/saltstack/pillar/project.sls>`_

The project Buildout
--------------------

Refer to `Odoo Starterkit <>`_ for buildout configuration and usage.

First run
==========

Once you've configured your buildout and project pillar, you're ready to run.

Within a terminal change directory to your server project, same level as the VagrantFile, and run 

    vagrant up

On first run, vagrant will provision the machine. It could take some time depending on your host and internet connection bandwidth.
Usually it's about 2 minutes for me to build the vm, 10 minutes to grab the whole Odoo repository and run the buildout.

Once it's done launch a browser an go to the url you've defined in `app.vm.hostname` within your `Vagrantfile <Vagrantfile>`_  and in the `fqdn` value from your `pillar project file <etc/saltstack/pillar/project.sls>`_

Default is https://myproject.vagrant

Default credentials are admin:admin

If you can't access it run vagrant provision to force the machine to provision.

    vagrant provision

Closing the vm
==============

Vagrant halt will shutdown gracefully the vm.

    vagrant halt

Connecting the vm through ssh
=============================

You can connect the vm at anytime once it's launched by typing command

    vagrant ssh

You'll be logged as the `vagrant` user. The `vagrant` user is also a passwordless sudoer, so you can run easily administrative tasks.

Provisioning
============

Normally at the first `vagrant up` command launch, it should automatically provision the vm.

Sometimes hangs can occur cause some packages or external ressources are unreachable. Be sure your vm can connect the internets..
Please also note that cloning the Odoo repository is quite long, (+/- 300mb)

If for any reasons you need to relaunch the provisioning steps, run

    vagrant provision

If it's still not a success and/or you want a more verbose output, connect through ssh

    vagrant ssh

And tail the salt logs in order to see what's going on when you run `vagrant provision`

    sudo tail -f /var/log/salt/minion

If you're still stuck, you can also manually run the salt provisioning command from guest after connecting through ssh with

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


