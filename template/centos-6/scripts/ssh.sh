#!/bin/bash

set -u
umask 0022

sed -i.dist \
  -e 's/^#*\(PermitRootLogin\).*/\1 without-password/' \
  -e 's/^#*\(UseDNS\).*/\1 no/' \
  /etc/ssh/sshd_config \
;

umask 0022
mkdir /etc/skel/.ssh
touch /etc/skel/.ssh/authorized_keys

