#!/bin/bash

set -u
umask 0022

vbox_version=$(cat ~root/.vbox_version)

rpm_pkglist=$(mktemp /tmp/${0##*/}.XXXXXXXX)
rpm -qa --queryformat '%{name}\n' |sort >"$rpm_pkglist"

yum install \
  --assumeyes \
  --disablerepo='*' \
  --enablerepo='BaseOS' \
  --enablerepo='AppStream' \
  tar \
  bzip2 \
  kernel-devel \
  elfutils-libelf-devel \
  gcc \
  perl \
;

mount -o ro,loop ~root/VBoxGuestAdditions_$vbox_version.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11

rpm -qa --queryformat '%{name}\n' \
|sort \
|diff "$rpm_pkglist" - \
|sed -n 's/^> //p' \
|xargs rpm -e \
;

umount /mnt
rm -f ~root/VBoxGuestAdditions_$vbox_version.iso
