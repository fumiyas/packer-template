#!/bin/bash

set -u
umask 0022

VBOX_VERSION=$(cat ~root/.vbox_version)

if [[ /etc/yum.repos.d/epel.repo ]]; then
  yum -y install \
    --disablerepo='*' \
    --enablerepo='base' \
    --enablerepo='epel' \
    bzip2 \
    dkms \
    make \
    perl \
  ;
else
  yum -y install \
    --disablerepo='*' \
    --enablerepo='base' \
    bzip2 \
    kernel-devel \
    make \
    gcc \
    perl \
  ;
fi

systemctl enable dkms.service

mount -o loop ~root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11 || :
umount /mnt
rm -f ~root/VBoxGuestAdditions_$VBOX_VERSION.iso

