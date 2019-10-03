#!/bin/bash

set -u
umask 0022

sed -i.dist \
  -e 's/^#*\(PermitRootLogin\).*/\1 prohibit-password/' \
  -e 's/^#*\(UseDNS\).*/\1 no/' \
  /etc/ssh/sshd_config \
;

mkdir /etc/skel/.ssh
touch /etc/skel/.ssh/authorized_keys
