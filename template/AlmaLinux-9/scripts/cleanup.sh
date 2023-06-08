#!/bin/bash

set -u
set -e
umask 0022

## Network configuration
## ======================================================================

systemctl start NetworkManager.service
nmcli radio all off

systemctl stop NetworkManager.service
rm -r /var/lib/NetworkManager/*

mkdir -p /etc/sysconfig/network-scripts/dist
for ifcfg in /etc/sysconfig/network-scripts/ifcfg-*; do
  [[ ! -f $ifcfg || ${ifcfg##*/} == ifcfg-lo ]] && continue
  mv "$ifcfg" /etc/sysconfig/network-scripts/dist/
done

## DNF
## ======================================================================

dnf remove linux-firmware --assumeyes
dnf clean all --enablerepo='*'

## Misc
## ======================================================================

rm -f /var/lib/systemd/random-seed
cp /dev/null /etc/machine-id
