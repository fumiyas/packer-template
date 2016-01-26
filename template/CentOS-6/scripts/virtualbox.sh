#!/bin/bash

set -u
umask 0022

VBOX_VERSION=$(cat ~root/.vbox_version)

if [[ /etc/yum.repos.d/epel.repo ]]; then
  yum -y install \
    --disablerepo='*' \
    --enablerepo='base' \
    --enablerepo='epel' \
    dkms \
    perl \
  ;
else
  yum -y install \
    --disablerepo='*' \
    --enablerepo='base' \
    kernel-devel \
    make \
    gcc \
    perl \
  ;
fi

chkconfig dkms_autoinstaller on

mount -o loop ~root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11 || :
umount /mnt
rm -f ~root/VBoxGuestAdditions_$VBOX_VERSION.iso

sed -i.dist \
  -e 's/^\(BUILT_MODULE_\)/#\1/' \
  /usr/src/vboxguest-*/dkms.conf \
;
sed -i.dist \
  -e 's/\(obj-m =.*\) vboxvideo\//\1/' \
  /usr/src/vboxguest-*/Makefile \
;

