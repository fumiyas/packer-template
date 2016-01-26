#!/bin/bash

set -u
umask 0022

el_ver=$(lsb_release -r |sed 's/^.*\s//')
el_ver_major="${el_ver%%.*}"

latest_baseurl="\n\
  http://ftp.iij.ad.jp/pub/linux/centos/$el_ver_major/os/\$basearch/\n\
  http://ftp.kddlabs.co.jp/Linux/packages/CentOS/$el_ver_major/os/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS/$el_ver_major/os/\$basearch/"
vault_baseurl="\n\
  http://centos.data-hotel.net/pub/linux/centos/\$releasever/os/\$basearch/\n\
  http://vault.centos.org/\$releasever/os/\$basearch/\n\
  http://archive.kernel.org/centos-vault/\$releasever/os/\$basearch/"

mkdir -p /etc/yum.repos.d/dist
cp -a /etc/yum.repos.d/*.repo /etc/yum.repos.d/dist

sed -i \
  -e "s/^\[/[C$el_ver_major-/" \
  -e '/^enabled=/d' \
   -e 's/^gpgcheck=.*/&\nenabled=0/' \
  -e 's!^mirrorlist=!#&!' \
  -e "s!^#*\(baseurl=\).*!\1$latest_baseurl!" \
  </etc/yum.repos.d/dist/CentOS-Base.repo \
  >/etc/yum.repos.d/CentOS-Base-Latest.repo \
;
sed -i \
  -e 's!^mirrorlist=!#&!' \
  -e "s!^#*\(baseurl=\).*!\1$vault_baseurl!" \
  </etc/yum.repos.d/dist/CentOS-Base.repo \
  >/etc/yum.repos.d/CentOS-Base.repo \
;

mkdir -m 0755 -p /etc/yum/vars
echo "$el_ver" >/etc/yum/vars/releasever

