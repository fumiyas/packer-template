#!/bin/bash

set -u
umask 0022

if [[ ! -f /etc/ssh/sshd_config.dist ]]; then
  cp -a /etc/ssh/sshd_config{,.dist}
fi

sed \
  -e 's/^#*\(PermitRootLogin\).*/\1 without-password/' \
  -e 's/^#*\(UseDNS\).*/\1 no/' \
  </etc/ssh/sshd_config.dist \
  >/etc/ssh/sshd_config \
;

mkdir -p /etc/skel/.ssh
cp /dev/null /etc/skel/.ssh/authorized_keys
