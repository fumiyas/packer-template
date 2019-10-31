#!/bin/bash

set -u
umask 0022

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)

latest_baseurl="\n\
  http://ftp.iij.ad.jp/pub/linux/centos/\$releasever/\\2/\$basearch/\n\
  http://ftp.kddlabs.co.jp/Linux/packages/CentOS/\$releasever/\\2/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$releasever/\\2/\$basearch/\n\
  http://mirror.centos.org/centos/\$releasever/\\2/\$basearch/"
fixed_baseurl="\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$fixedver/\\2/\$basearch/\n\
  http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$fixedver/\\2/\$basearch/\n\
  http://mirror.centos.org/centos/\$fixedver/\\2/\$basearch/\n\
  http://vault.centos.org/\$fixedver/\\2/\$basearch/\n\
  http://archive.kernel.org/centos-vault/\$fixedver/\\2/\$basearch/"

echo "$el_ver" >"/etc/yum/vars/fixedver"

mkdir -p /etc/yum.repos.d/dist

for repo_name in Base AppStream Extras; do
  repo="/etc/yum.repos.d/CentOS-$repo_name.repo"
  repo_fixedver="/etc/yum.repos.d/CentOS-$repo_name-FixedVer.repo"
  repo_dist="/etc/yum.repos.d/dist/CentOS-$repo_name.repo"

  if [[ ! -f $repo_dist ]]; then
    cp -a "$repo" "$repo_dist"
  fi

  sed \
    -e "s/^\[/[FixedVer-/" \
    -e 's!^\(name=.*\)\$releasever!\1$fixedver!' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*/\([a-z]*\)/[^/]*/\$!\1$fixed_baseurl!" \
    <"$repo_dist" \
    >"$repo_fixedver" \
  ;

  sed \
    -e '/^enabled=/d' \
    -e 's/^gpgcheck=.*/&\nenabled=0/' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*/\([a-z]*\)/[^/]*/\$!\1$latest_baseurl!" \
    <"$repo_dist" \
    >"$repo" \
  ;
done
