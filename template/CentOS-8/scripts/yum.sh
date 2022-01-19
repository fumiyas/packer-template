#!/bin/bash

set -u
set -e
umask 0022

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)

latest_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos/\$releasever/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$releasever/\\2/\$basearch/\\3/,\
http://mirror.centos.org/\$contentdir/\$releasever/\\2/\$basearch/\\3/\
"
fixed_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos/\$fixedver/\\2/\$basearch/\\3/,\
http://ftp.iij.ad.jp/pub/linux/centos-vault/\$fixedver/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$fixedver/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$fixedver/\\2/\$basearch/\\3/,\
http://mirror.centos.org/\$contentdir/\$fixedver/\\2/\$basearch/\\3/,\
https://vault.centos.org/\$fixedver/\\2/\$basearch/\\3/,\
https://archive.kernel.org/centos-vault/\$fixedver/\\2/\$basearch/\\3/\
"
kickstart_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos/\$fixedver/\\2/\$basearch/kickstart/,\
http://ftp.iij.ad.jp/pub/linux/centos-vault/\$fixedver/\\2/\$basearch/kickstart/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS/\$fixedver/\\2/\$basearch/kickstart/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$fixedver/\\2/\$basearch/kickstart/,\
http://mirror.centos.org/\$contentdir/\$fixedver/\\2/\$basearch/kickstart/,\
https://vault.centos.org/\$fixedver/\\2/\$basearch/kickstart/,\
https://archive.kernel.org/centos-vault/\$fixedver/\\2/\$basearch/kickstart/\
"

echo "$el_ver" >"/etc/yum/vars/fixedver"

mkdir -p /etc/yum.repos.d/dist

for repo_name in Base AppStream Extras PowerTools Devel HA; do
  repo="/etc/yum.repos.d/CentOS-$repo_name.repo"
  repo_fixedver="/etc/yum.repos.d/CentOS-$repo_name-FixedVer.repo"
  repo_kickstart="/etc/yum.repos.d/CentOS-$repo_name-Kickstart.repo"
  repo_dist="/etc/yum.repos.d/dist/CentOS-$repo_name.repo"

  if [[ ! -f $repo_dist ]]; then
    cp -a "$repo" "$repo_dist"
  fi

  sed \
    -e 's/^\[\(.*\)\]/[\L\1]/' \
    -e 's/^enabled=.*/enabled=0/' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#* *\(baseurl=\).*/\([a-zA-Z]*\)/[^/]*/\([a-z]*\)/\$!\1$latest_baseurl!" \
    <"$repo_dist" \
    >"$repo" \
  ;

  sed \
    -e 's/^\[\(.*\)\]/[\L\1]/' \
    -e "s/^\[/[fixedver-/" \
    -e 's!^\(name=.*\)\$releasever!\1$fixedver!' \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#* *\(baseurl=\).*/\([a-zA-Z]*\)/[^/]*/\([a-z]*\)/\$!\1$fixed_baseurl!" \
    <"$repo_dist" \
    >"$repo_fixedver" \
  ;

  if [[ $repo_name == @(Base|AppStream) ]]; then
    sed \
      -e 's/^\[\(.*\)\]/[\L\1]/' \
      -e "s/^\[/[kickstart-/" \
      -e 's/^enabled=.*/enabled=0/' \
      -e 's!^\(name=.*\)\$releasever!\1$fixedver Kickstart!' \
      -e 's!^mirrorlist=!#&!' \
      -e "s!^#* *\(baseurl=\).*/\([a-zA-Z]*\)/[^/]*/\([a-z]*\)/\$!\1$kickstart_baseurl!" \
      <"$repo_dist" \
      >"$repo_kickstart" \
    ;
  fi
done
