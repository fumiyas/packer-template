#!/bin/bash

set -u
umask 0022

VBOX_VERSION=$(cat ~root/.vbox_version)

yum -y install \
  --disablerepo='*' \
  --enablerepo='base' \
  kernel-devel \
  make \
  gcc \
  perl \
  bzip2 \
;

mount -o loop ~root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11 || :
umount /mnt
rm -f ~root/VBoxGuestAdditions_$VBOX_VERSION.iso

