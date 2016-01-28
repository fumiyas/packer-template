#!/bin/bash

set -u
umask 0022

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)
el_ver_major="${el_ver%%.*}"

latest_baseurl="\n\
  http://ftp.iij.ad.jp/pub/linux/centos/$el_ver_major/\\2/\$basearch/\n\
  http://ftp.kddlabs.co.jp/Linux/packages/CentOS/$el_ver_major/\\2/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS/$el_ver_major/\\2/\$basearch/\n\
  http://mirror.centos.org/centos/$el_ver_major/\\2/\$basearch/"
vault_baseurl="\n\
  http://centos.data-hotel.net/pub/linux/centos/\$releasever/\\2/\$basearch/\n\
  http://vault.centos.org/\$releasever/\\2/\$basearch/\n\
  http://archive.kernel.org/centos-vault/\$releasever/\\2/\$basearch/"

mkdir -p /etc/yum.repos.d/dist
cp -a /etc/yum.repos.d/CentOS-*.repo /etc/yum.repos.d/dist

sed \
  -e 's!^mirrorlist=!#&!' \
  -e "s!^#*\(baseurl=\).*/\([a-z]*\)/[^/]*/\$!\1$vault_baseurl!" \
  </etc/yum.repos.d/dist/CentOS-Base.repo \
  >/etc/yum.repos.d/CentOS-Base.repo \
;

sed \
  -e "s/^\[/[C$el_ver_major-/" \
  -e '/^enabled=/d' \
  -e 's/^gpgcheck=.*/&\nenabled=0/' \
  -e 's!^mirrorlist=!#&!' \
  -e "s!^#*\(baseurl=\).*/\([a-z]*\)/[^/]*/\$!\1$latest_baseurl!" \
  </etc/yum.repos.d/dist/CentOS-Base.repo \
  >/etc/yum.repos.d/CentOS-Base-Latest.repo \
;

mkdir -m 0755 -p /etc/yum/vars
echo "$el_ver" >/etc/yum/vars/releasever

