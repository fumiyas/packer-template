#!/bin/bash

set -u
set -e
umask 0022

vbox_version=$(cat ~root/.vbox_version)

rpm_pkglist=$(mktemp /tmp/${0##*/}.XXXXXXXX)
rpm -qa --queryformat '%{name}\n' |sort >"$rpm_pkglist"

dnf install \
  --assumeyes \
  --setopt=install_weak_deps=False \
  --disablerepo='*' \
  --enablerepo='kickstart-baseos' \
  --enablerepo='kickstart-appstream' \
  tar \
  bzip2 \
  kernel-devel \
  elfutils-libelf-devel \
  gcc \
  perl \
;

mount -o ro,loop /root/VBoxGuestAdditions_$vbox_version.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11

set +e
umount /mnt
rm -f /root/VBoxGuestAdditions_$vbox_version.iso
if [[ -s $rpm_pkglist ]]; then
  rpm -qa --queryformat '%{name}\n' \
  |sort \
  |diff "$rpm_pkglist" - \
  |sed -n 's/^> //p' \
  |xargs dnf remove \
  ;
fi
