#!/bin/bash

set -u
set -e

cp -a /etc/default/grub{,.dist}
sed -i \
  -e 's/ rhgb\( \|"\)/\1/' \
  -e 's/ quiet\( \|"\)/\1/' \
  /etc/default/grub \
;
grub2-mkconfig -o /boot/grub2/grub.cfg

systemctl disable kdump.service
systemctl enable getty@ttyS0.service

if dmesg |grep -q VirtualBox; then
  ## https://access.redhat.com/site/solutions/58625 (subscription required)
  echo 'RES_OPTIONS="single-request-reopen"' >>/etc/sysconfig/network
  #for ifname in $(nmcli --terse --fields NAME connection); do
  #  nmcli connection modify "$ifname" ipv4.dns-options 'single-request-reopen'
  #done
fi
