#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

set -x

ovs-vsctl -- --may-exist add-br br-int
ovs-vsctl -- --may-exist add-port br-int eth2
ip link set dev eth2 up
ovs-vsctl br-set-external-id br-int bridge-id br-int
ovs-vsctl set-controller br-int tcp:192.168.2.10:6633

