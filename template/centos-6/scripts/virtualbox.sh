#!/bin/bash

VBOX_VERSION=$(cat ~vagrant/.vbox_version)

yum -y install \
  --disablerepo='*' \
  --enablerepo='base' \
  kernel-devel \
  make \
  gcc \
  perl \
  bzip2 \
;

mount -o loop ~vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11 || :
umount /mnt
rm -f ~vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso

