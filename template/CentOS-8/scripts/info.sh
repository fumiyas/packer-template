#!/bin/bash

set -u
set +e
set -x
exec 1>&2

uname -a
lscpu
free
lsblk --all --output name,kname,type,fstype,size,sched,uuid,ro,mountpoint
cat /etc/fstab
df -h

rpm -qa
chkconfig --list
systemctl --all
systemctl list-unit-files
systemd-cgls --all --full
journalctl --boot --catalog

sestatus

ip addr
ip route
ss -aeiomp
if firewall-cmd --state >/dev/null 2>&1; then
  ## FIXME: Dump more information
  firewall-cmd --list-all-zones --permanent
fi
