#!/bin/bash

set -u
set -e
umask 0022

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)

latest_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos-vault/\$contentdir/\$releasever/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$contentdir/\$releasever/\\2/\$basearch/\\3/,\
https://vault.centos.org/\$contentdir/\$releasever/\\2/\$basearch/\\3/,\
https://archive.kernel.org/centos-vault/\$contentdir/\$releasever/\\2/\$basearch/\\3/\
"
fixed_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos-vault/\$contentdir/\$fixedver/\\2/\$basearch/\\3/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$contentdir/\$fixedver/\\2/\$basearch/\\3/,\
https://vault.centos.org/\$contentdir/\$fixedver/\\2/\$basearch/\\3/,\
https://archive.kernel.org/centos-vault/\$contentdir/\$fixedver/\\2/\$basearch/\\3/\
"
kickstart_baseurl="\
http://ftp.iij.ad.jp/pub/linux/centos-vault/\$contentdir/\$fixedver/\\2/\$basearch/kickstart/,\
http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/\$contentdir/\$fixedver/\\2/\$basearch/kickstart/,\
https://vault.centos.org/\$contentdir/\$fixedver/\\2/\$basearch/kickstart/,\
https://archive.kernel.org/centos-vault/\$contentdir/\$fixedver/\\2/\$basearch/kickstart/\
"

echo "$el_ver" >"/etc/yum/vars/fixedver"

mkdir -p /etc/yum.repos.d/dist

for repo in /etc/yum.repos.d/CentOS-*.repo; do
  [[ ! -f $repo ]] && continue

  repo_basename=$(basename "$repo" .repo)
  repo_name="${repo_basename##*-}"
  [[ $repo_name == @(FixedVer|Kickstart) ]] && continue

  repo_dist="/etc/yum.repos.d/dist/$repo_basename.repo"
  repo_fixedver="/etc/yum.repos.d/$repo_basename-FixedVer.repo"
  repo_kickstart="/etc/yum.repos.d/$repo_basename-Kickstart.repo"

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

  if [[ $repo_name == @(Base|BaseOS|AppStream) ]]; then
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

## ======================================================================

dnf install \
  --assumeyes \
  --setopt=install_weak_deps=False \
  --disablerepo='*' \
  --enablerepo='kickstart-baseos' \
  --enablerepo='kickstart-appstream' \
  langpacks-ja \
  glibc-langpack-ja \
;

dnf remove \
  --assumeyes \
  linux-firmware \
  glibc-all-langpacks \
;
