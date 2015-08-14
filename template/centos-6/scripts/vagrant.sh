#!/bin/bash

LC_TIME=C date >/etc/vagrant_box_build_time

groupadd --system vagrant
useradd --system -g vagrant -d /srv/vagrant -s /bin/bash -m vagrant

echo "umask 022" >>/srv/vagrant/.bashrc
echo "Defaults:vagrant !requiretty" >/etc/sudoers.d/vagrant
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers.d/vagrant

mkdir -p ~vagrant/.ssh
curl \
  --insecure \
  --location \
  --output ~vagrant/.ssh/authorized_keys \
  https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
;
chown -hR vagrant: ~vagrant/.ssh

