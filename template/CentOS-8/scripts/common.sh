#!/bin/bash

set -u
set -e

systemctl disable kdump.service

ln -s ../x/xterm-256color /usr/share/terminfo/m/mlterm-256color

if dmesg |grep -q VirtualBox; then
  if [[ ! -f /etc/sysconfig/network.dist ]]; then
    cp -a /etc/sysconfig/network{,.dist}
  fi
  cp -a /etc/sysconfig/network{.dist,}
  ## https://access.redhat.com/site/solutions/58625 (subscription required)
  echo 'RES_OPTIONS="single-request-reopen"' >>/etc/sysconfig/network
  #for ifname in $(nmcli --terse --fields NAME connection); do
  #  nmcli connection modify "$ifname" ipv4.dns-options 'single-request-reopen'
  #done
fi
