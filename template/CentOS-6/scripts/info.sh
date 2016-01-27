#!/bin/bash

set -x

uname -a
lscpu
free
lsblk --all --output name,kname,type,fstype,size,sched,uuid,ro,mountpoint
cat /etc/fstab
df -h

rpm -qa
chkconfig --list

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

