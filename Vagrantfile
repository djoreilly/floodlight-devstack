# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "raring64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.define :controller do |controller_config|
    controller_config.vm.hostname = "controller"
    controller_config.vm.network :private_network, ip: "192.168.2.10"
    # ignore the ip address in next line - it won't be set in the VM
    controller_config.vm.network :private_network, ip: "192.168.3.10", auto_config: false
    controller_config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--uart1", "0x3F8", 4]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype3", "virtio"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
    controller_config.vm.provision :ansible do |ansible|
      ansible.playbook = "devstack.yml"
      ansible.inventory_file = "ansible_hosts"
      ansible.limit = "controller"
      ansible.verbose = true
    end
  end

  config.vm.define :compute1 do |compute1_config|
    compute1_config.vm.hostname = "compute1"
    compute1_config.vm.network :private_network, ip: "192.168.2.11"
    # ignore the ip address in next line - it won'tbe set in the VM
    compute1_config.vm.network :private_network, ip: "192.168.3.11", auto_config: false
    compute1_config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--uart1", "0x3F8", 4]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype3", "virtio"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
    compute1_config.vm.provision :ansible do |ansible|
      ansible.playbook = "devstack.yml"
      ansible.inventory_file = "ansible_hosts"
      ansible.limit = "compute1"
      ansible.verbose = true
    end
  end

end
