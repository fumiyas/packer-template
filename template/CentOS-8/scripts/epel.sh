#!/bin/bash
##
## Extra Packages for Enterprise Linux (EPEL) repository
##

set -u
set -e

yum install --assumeyes epel-release

mkdir -p /etc/yum.repos.d/dist
cp -a /etc/yum.repos.d/epel{,-*}.repo /etc/yum.repos.d/dist/

sed -i \
  -e '/^enabled=/d' \
  -e 's/^gpgcheck=.*/&\nenabled=0/' \
  /etc/yum.repos.d/epel{,-*}.repo \
;
