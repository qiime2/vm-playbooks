# -*- mode: ruby -*-
# # vi: set ft=ruby :

require "json"

variables = JSON.parse(File.read(File.join(File.dirname(__FILE__), "variables.json")))

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.gui = true
  end

  config.vm.provision "shell",
    path: "./bin/00_bootstrap.sh"

  config.vm.provision "shell",
    inline: "sudo apt-get install ubuntu-desktop -y"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/packer-qiime2.yml"
    ansible.extra_vars = {
      miniconda_path: variables["miniconda_path"],
      ssh_username: variables["ssh_username"],
      ssh_password: variables["ssh_pass_hash"],
      hostname: "DEVBLD",
      with_users: "true",
    }
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/vbox-teardown.yml"
  end

end
