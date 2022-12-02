#!/bin/bash

set -u
set -e

if [[ ! -f /etc/default/grub.dist ]]; then
  cp -a /etc/default/grub{,.dist}
fi

sed \
  -E \
  -e '/^GRUB_CMDLINE_LINUX=/ { s/([" ])rhgb([" ])/\1\2/; s/  +/ /g; }' \
  -e '/^GRUB_CMDLINE_LINUX=/ { s/([" ])quiet([" ])/\1\2/; s/  +/ /g; }' \
  -e '/^GRUB_CMDLINE_LINUX=/ { s/([" ])crashkernel=\w+([" ])/\1\2/; s/  +/ /g; }' \
  </etc/default/grub.dist \
  >/etc/default/grub \
;
grub2-mkconfig -o /boot/grub2/grub.cfg

systemctl disable kdump.service
systemctl enable getty@ttyS0.service

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
