#!/bin/bash

set -u
umask 0022

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)

latest_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos/\$releasever/\\2/\$basearch/\\3/,\
http://ftp.kddlabs.co.jp/Linux/packages/CentOS/\$releasever/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$releasever/\\2/\$basearch/\\3/,\
http://mirror.centos.org/\$contentdir/\$releasever/\\2/\$basearch/\\3/\
"
fixed_baseurl="\
http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$fixedver/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$fixedver/\\2/\$basearch/\\3/,\
http://mirror.centos.org/\$contentdir/\$fixedver/\\2/\$basearch/\\3/,\
http://vault.centos.org/\$fixedver/\\2/\$basearch/\\3/,\
http://archive.kernel.org/centos-vault/\$fixedver/\\2/\$basearch/\\3/\
"

echo "$el_ver" >"/etc/yum/vars/fixedver"

mkdir -p /etc/yum.repos.d/dist
cp -a /etc/yum.repos.d/CentOS-*.repo /etc/yum.repos.d/dist

for repo in Base AppStream Extras; do
  sed \
    -e "s/^\[/[FixedVer-/" \
    -e 's!^\(name=.*\)\$releasever!\1$fixedver!' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*/\([a-zA-Z]*\)/[^/]*/\([a-z]*\)/\$!\1$fixed_baseurl!" \
    </etc/yum.repos.d/dist/CentOS-$repo.repo \
    >/etc/yum.repos.d/CentOS-$repo-FixedVer.repo \
  ;

  sed \
    -e '/^enabled=/d' \
    -e 's/^gpgcheck=.*/&\nenabled=0/' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*/\([a-zA-Z]*\)/[^/]*/\([a-z]*\)/\$!\1$latest_baseurl!" \
    </etc/yum.repos.d/dist/CentOS-$repo.repo \
    >/etc/yum.repos.d/CentOS-$repo.repo \
  ;
done
