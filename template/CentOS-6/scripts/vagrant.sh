#!/bin/bash

set -u
umask 0022

LC_TIME=C date >/etc/vagrant_box_build_time

vagrant_home="/srv/vagrant"

groupadd --system vagrant
useradd --system -g vagrant -d "$vagrant_home" -s /bin/bash -m vagrant

echo 'umask 0022' >>"$vagrant_home/.bashrc"
echo 'Defaults:vagrant !requiretty' >/etc/sudoers.d/vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/vagrant

mkdir -p "$vagrant_home/.ssh"
curl \
  --insecure \
  --location \
  --output "$vagrant_home/.ssh/authorized_keys" \
  https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
;
chown -R vagrant: "$vagrant_home/.ssh"
