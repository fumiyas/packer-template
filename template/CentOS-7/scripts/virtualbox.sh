#!/bin/bash

set -u
umask 0022

vbox_version=$(cat ~root/.vbox_version)

rpm_pkglist=$(mktemp /tmp/${0##*/}.XXXXXXXX)
rpm -qa --queryformat '%{name}\n' |sort >"$rpm_pkglist"

sigexit_handler() {
  local rc="$?"
  set +e

  umount /mnt

  if [[ -s $rpm_pkglist ]]; then
    rpm -qa --queryformat '%{name}\n' \
    |sort \
    |diff "$rpm_pkglist" - \
    |sed -n 's/^> //p' \
    |xargs rpm -e \
    ;
  fi

  if [[ $rc -eq 0 ]]; then
    rm -f /root/VBoxGuestAdditions_$vbox_version.iso
  fi

  exit "$rc"
}

trap sigexit_handler EXIT

yum install \
  --assumeyes \
  --disablerepo='*' \
  --enablerepo='base' \
  bzip2 \
  kernel-devel \
  make \
  gcc \
;

mount -o ro,loop /root/VBoxGuestAdditions_$vbox_version.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11
