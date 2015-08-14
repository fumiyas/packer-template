#!/bin/bash

set -u
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='base' \
  fuse-libs \
;

mount -o loop ~vagrant/linux.iso /mnt
tar xzf /mnt/VMwareTools-*.tar.gz -C /tmp/
umount /mnt
rm ~vagrant/linux.iso

/tmp/vmware-tools-distrib/vmware-install.pl -d
rm -rf /tmp/vmware-tools-distrib

