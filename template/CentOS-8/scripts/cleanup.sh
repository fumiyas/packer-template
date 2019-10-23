#!/bin/bash

set -u
umask 0022

## Network configuration
## ======================================================================

nmcli radio all off

systemctl stop NetworkManager.service
rm -r /var/lib/NetworkManager/*

mkdir /etc/sysconfig/network-scripts/dist
for ifcfg in /etc/sysconfig/network-scripts/ifcfg-*; do
  [[ ${ifcfg##*/} == ifcfg-lo ]] && continue
  mv "$ifcfg" /etc/sysconfig/network-scripts/dist/
done

## Yum
## ======================================================================

yum clean all
