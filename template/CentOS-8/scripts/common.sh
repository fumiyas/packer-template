#!/bin/bash

set -u
set -e

if [[ ! -f /etc/default/grub.dist ]]; then
  cp -a /etc/default/grub{,.dist}
fi

sed \
  -e 's/ rhgb\( \|"\)/\1/' \
  -e 's/ quiet\( \|"\)/\1/' \
  </etc/default/grub.dist \
  >/etc/default/grub \
;
grub2-mkconfig -o /boot/grub2/grub.cfg

systemctl disable kdump.service

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
