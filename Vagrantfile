# -*- mode: ruby -*-
# vi: set ft=ruby :
#: vim: sts=2 ts=2 sw=2 et ai

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "Debian/Wheezy"
  config.vm.box_url = "https://www.dropbox.com/s/mw4764koy0k7bfp/vagrant-debian-wheezy-64-7.6.0-fr.box?dl=1"
  
  config.vm.synced_folder "etc/saltstack/salt/", "/srv/salt/"
  config.vm.synced_folder "etc/saltstack/pillar/", "/srv/pillar/"

  config.vm.synced_folder "myproject_buildout/", "/vagrant/myproject_buildout/", owner: "vagrant", group: "www-data"

  config.vm.provider :virtualbox do |vm|
    vm.gui = false
    vm.customize(["modifyvm", :id, "--rtcuseutc", "on"])
    vm.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Salt Minion - odoo-vagrant-vm
  config.vm.define "odoo-vagrant-vm" do |minion|
    minion.vm.hostname = "myproject.vagrant"
    minion.vm.network :private_network, ip: "192.168.56.132"
    minion.vm.network :public_network, ip: "192.168.0.132"

    minion.vm.provision :salt do |salt|
      salt.install_type = "git"
      salt.always_install = true
      salt.install_args = "v2014.1.10"
      salt.colorize = true
      salt.minion_config = "etc/saltstack/minions/odoo-vagrant-vm.conf"
      salt.run_highstate = true
    end
  end
end
