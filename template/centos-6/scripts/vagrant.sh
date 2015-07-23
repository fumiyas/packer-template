#!/bin/bash

LC_TIME=C date >/etc/vagrant_box_build_time

mkdir -p ~vagrant/.ssh
curl \
  --insecure \
  --location \
  --output ~vagrant/.ssh/authorized_keys \
  https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
;
chown -hR vagrant: ~vagrant/.ssh

