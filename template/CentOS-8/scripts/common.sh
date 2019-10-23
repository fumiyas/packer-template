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

if dmesg |grep -q VirtualBox; then
  ## https://access.redhat.com/site/solutions/58625 (subscription required)
  echo 'RES_OPTIONS="single-request-reopen"' >>/etc/sysconfig/network
  #for ifname in $(nmcli --terse --fields NAME connection); do
  #  nmcli connection modify "$ifname" ipv4.dns-options 'single-request-reopen'
  #done
fi

mkdir -m 0755 /etc/sysconfig/network-scripts/dist
cp -p \
  /etc/sysconfig/network-scripts/ifcfg-* \
  /etc/sysconfig/network-scripts/dist/ \
;
for ifcfg in /etc/sysconfig/network-scripts/ifcfg-*; do
  sed -i \
    -e '/^HWADDR=/d' \
    -e '/^UUID=/d' \
    "$ifcfg" \
  ;
done
