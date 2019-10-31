#!/bin/bash

set -u
umask 0022

LC_TIME=C date >/etc/vagrant_box_build_time

vagrant_home="/srv/vagrant"

getent group vagrant >/dev/null \
  || groupadd --system vagrant \
;
getent passwd vagrant >/dev/null \
  || useradd --system -g vagrant -d "$vagrant_home" -s /bin/bash -m vagrant \
;

if [[ ! -f $vagrant_home/.bashrc.dist ]]; then
  cp -a "$vagrant_home/.bashrc"{,.dist}
fi
cp -a "$vagrant_home/.bashrc"{.dist,}
echo 'umask 0022' >>"$vagrant_home/.bashrc"

cat <<'EOF' >/etc/sudoers.d/vagrant
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD: ALL
EOF

mkdir -p "$vagrant_home/.ssh"
curl \
  --insecure \
  --location \
  --output "$vagrant_home/.ssh/authorized_keys" \
  https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
;
chown -hR vagrant: "$vagrant_home/.ssh"
