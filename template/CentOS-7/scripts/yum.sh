#!/bin/bash

set -u
set -e
umask 0022

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)

latest_baseurl="\n\
  http://ftp.iij.ad.jp/pub/linux/centos/\$releasever/\\2/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$releasever/\\2/\$basearch/\n\
  https://vault.centos.org/centos/\$releasever/\\2/\$basearch/\n\
  https://archive.kernel.org/centos-vault/centos/\$releasever/\\2/\$basearch/"
fixed_baseurl="\n\
  http://ftp.iij.ad.jp/pub/linux/centos/\$fixedver/\\2/\$basearch/\n\
  http://ftp.iij.ad.jp/pub/linux/centos-vault/centos/\$fixedver/\\2/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$fixedver/\\2/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/centos/\$fixedver/\\2/\$basearch/\n\
  https://vault.centos.org/centos/\$fixedver/\\2/\$basearch/\n\
  https://archive.kernel.org/centos-vault/centos/\$fixedver/\\2/\$basearch/"

echo "$el_ver" >"/etc/yum/vars/fixedver"

mkdir -p /etc/yum.repos.d/dist

for repo_name in Base; do
  repo="/etc/yum.repos.d/CentOS-$repo_name.repo"
  repo_fixedver="/etc/yum.repos.d/CentOS-$repo_name-FixedVer.repo"
  repo_dist="/etc/yum.repos.d/dist/CentOS-$repo_name.repo"

  if [[ ! -f $repo_dist ]]; then
    cp -a "$repo" "$repo_dist"
  fi

  sed \
    -e 's/^\[\(.*\)\]/[\L\1]/' \
    -e '/^enabled=/d' \
    -e 's/^gpgcheck=.*/&\nenabled=0/' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*/\([a-z]*\)/[^/]*/\$!\1$latest_baseurl!" \
    <"$repo_dist" \
    >"$repo" \
  ;

  sed \
    -e 's/^\[\(.*\)\]/[\L\1]/' \
    -e "s/^\[/[fixedver-/" \
    -e 's!^\(name=.*\)\$releasever!\1$fixedver!' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*/\([a-z]*\)/[^/]*/\$!\1$fixed_baseurl!" \
    <"$repo_dist" \
    >"$repo_fixedver" \
  ;
done
