#!/bin/sh

set -u
umask 0022

## ======================================================================

apk add sudo || exit $?

## ======================================================================

sed -i.dist \
  -e 's/^#*\(PermitRootLogin\).*/\1 without-password/' \
  -e 's/^#*\(UseDNS\).*/\1 no/' \
  /etc/ssh/sshd_config \
|| exit $? \
;

mkdir -p /etc/skel/.ssh || exit $?
touch /etc/skel/.ssh/authorized_keys || exit $?

## ======================================================================

LC_TIME=C date >/etc/vagrant_box_build_time

vagrant_home="/srv/vagrant"

addgroup -S vagrant || exit $?
adduser -S -D -G vagrant -h "$vagrant_home" vagrant || exit $?

echo 'Defaults:vagrant !requiretty' >/etc/sudoers.d/vagrant || exit $?
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/vagrant || exit $?

mkdir -p "$vagrant_home/.ssh" || exit $?
wget \
  -O "$vagrant_home/.ssh/authorized_keys" \
  https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
|| exit $? \
;
chown -R vagrant: "$vagrant_home/.ssh" || exit $?

## ======================================================================

exit 0
