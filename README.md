floodlight-devstack
===================

This repository provides some scripts to make it easier to get [devstack](http://devstack.org/) up and running with the [BigSwitch RestProxy Neutron plugin](https://github.com/openstack/neutron/blob/master/neutron/plugins/bigswitch/plugin.py) and the [Floodlight](http://www.projectfloodlight.org/floodlight/) OpenFlow controller.

First a Vagrant script creates two Ubuntu Raring (13.04) VMs - a controller and a compute node. It gives each VM a nic3 (eth2 inside the VM) connnected to a VirtualBox host-only network which is used to interconnect the br-int bridges. Vagrant does not configure these interfaces for IP.

Vagrant then calls an Ansible provisioner script to put any required packages and repositories in place. It installs Open vSwitch and clones the Floodlight and devstack git repos. It also copies a devstack localrc to each node. These localrcs are already customised for this scenario. It also copies a script named ovs-init.sh that you must run before running devstack on each node. It creates the br-int bridge, points it at Floodlight, and connects eth2.

![image](../master/floodlight-devstack.png?raw=true)

Requirements
------------

* [Vagrant](http://www.vagrantup.com/) (works with 1.2)
* [Ansible](http://www.ansibleworks.com/) (works with 1.2)
* [VirtualBox](https://www.virtualbox.org/) (works with 4.2)

Steps
-----

    git clone https://github.com/djoreilly/floodlight-devstack.git
    cd floodlight-devstack
    vagrant up

After the nodes are up, build and run the Floodlight controller:

    vagrant ssh controller
    cd floodlight; ant
    java -jar target/floodlight.jar -cf src/main/resources/quantum.properties

Start a new console and run devstack on the controller:

    vagrant ssh controller
    sudo ./ovs-init.sh
    # check that a new switch was seen in the Floodlight console log
    cd devstack
    ./stack.sh

When complete, run devstack on the compute node

    vagrant ssh compute1
    sudo ./ovs-init.sh
    # check that a new switch was seen in the Floodlight console log
    # there should also be some messages about an inter-switch link being detected
    cd devstack
    ./stack.sh


After, check the [screens](http://www.samsarin.com/blog/2007/03/11/gnu-screen-working-with-the-scrollback-buffer/) are ok

    ./rejoin-stack.sh

Horizon should be at [http://192.168.2.10](http://192.168.2.10). Login with user=admin and password=password. Change to tenant demo to see the network name "private" that was created by devstack.
Tip - create a new flavor with just 64MB of RAM, as that is all the cirros image needs. Start a VM on "private" and use the VNC console to check that it gets an IP from DHCP.

Or use the Nova and Neutron CLI

    source /vagrant/openrc-admin
    neutron net-list

Notes
-----
The [doc](http://www.openflowhub.org/display/floodlightcontroller/Install+Floodlight+and+OpenStack+on+Your+Own+Ubuntu+VM) says to disable IP namespaces, but I think that is messy, so I enabled them and use a veth to connect the dhcp namespace to br-int. So to access the Neutron network from the controller node, you will need to use 'ip netns' to find the namespace name and then 'ip netns exec ip-namespace-name some-net-command' to run a command in the namespace.

TODO lots of limitations...
