#!/bin/bash
##
## Extra Packages for Enterprise Linux (EPEL) repository
##

set -u
set -e

el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)
if [[ ${el_ver#*.} -le 4 ]]; then
  ## yum with nss-3.14.0.0-12.el6 (bundled in CentOS 6.4) fails
  ## to connect to https://mirrors.fedoraproject.org
  yum -y install --disablerepo='*' --enablerepo=updates nss
fi

epel_url_prefix="https://download.fedoraproject.org/pub/epel"
el_ver=$(sed 's/ *(.*//;s/.* //' /etc/redhat-release)
el_ver_major="${el_ver%%.*}"
el_arch=$(uname -m)

epel_url="$epel_url_prefix/$el_ver_major/$el_arch/Packages"

epel_release_rpm=$(
  curl \
    --location \
    "$epel_url/e/" \
  |sed \
    -n \
    's/.*<a href="\(epel-release-[0-9]\{1,\}-[0-9]\{1,\}\.noarch\.rpm\)".*/\1/p' \
  ;
)

rpm -iv "$epel_url/e/$epel_release_rpm"

mkdir -p /etc/yum.repos.d/dist
cp -a /etc/yum.repos.d/epel{,-*}.repo /etc/yum.repos.d/dist/

sed -i \
  -e '/^enabled=/d' \
  -e 's/^gpgcheck=.*/&\nenabled=0/' \
  /etc/yum.repos.d/epel{,-*}.repo \
;
