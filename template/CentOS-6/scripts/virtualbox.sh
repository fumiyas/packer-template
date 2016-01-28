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

chkconfig dkms_autoinstaller on

mount -o loop ~root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11 || :
umount /mnt
rm -f ~root/VBoxGuestAdditions_$VBOX_VERSION.iso

## Building vboxvideo.ko fails with kernel-devel on CentOS 6,
## thus remove it from the build target.
sed -i.dist \
   -e '/^BUILT_MODULE_NAME\[[0-9]*\]="vboxvideo"/,/^\(BUILT_MODULE_NAME\[\|$\)/s/^/#/' \
  /usr/src/vboxguest-*/dkms.conf \
;
sed -i.dist \
  -e 's/\(obj-m =.*\) vboxvideo\//\1/' \
  /usr/src/vboxguest-*/Makefile \
;

