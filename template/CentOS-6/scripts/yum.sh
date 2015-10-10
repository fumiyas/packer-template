#!/bin/bash

set -u
umask 0022

baseurl="http://vault.centos.org/\$releasever/os/\$basearch/\n\
  http://archive.kernel.org/centos/\$releasever/os/\$basearch/"

mkdir -p /etc/yum/vars
sed 's/ *(.*//;s/.* //' /etc/redhat-release >/etc/yum/vars/releasever

mkdir -p /etc/yum.repos.d/dist
cp -a /etc/yum.repos.d/*.repo /etc/yum.repos.d/dist
for f in /etc/yum.repos.d/*.repo; do
  sed -i \
    -e 's!^mirrorlist=!#&!' \
    -e "s!^#*\(baseurl=\).*!\1$baseurl!" \
    "$f" \
  ;
done

