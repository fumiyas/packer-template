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
iptables -nvL -t filter
iptables -nvL -t nat
iptables -nvL -t mangle
iptables -nvL -t raw
iptables -nvL -t security
ip6tables -nvL -t filter
ip6tables -nvL -t nat
ip6tables -nvL -t mangle
ip6tables -nvL -t raw
ip6tables -nvL -t security

