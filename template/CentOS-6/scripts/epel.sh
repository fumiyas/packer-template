#!/bin/bash
##
## Extra Packages for Enterprise Linux (EPEL) repository
##

set -u
set -e

epel_url_prefix="http://download.fedoraproject.org/pub/epel"
el_ver=$(lsb_release -r |sed 's/^.*\s//;s/\..*//')
el_arch=$(uname -m)

epel_url="$epel_url_prefix/$el_ver/$el_arch"

epel_release_url=$(
  curl \
    --location \
    "$epel_url/repoview/epel-release.html" \
  |sed \
    -n \
    's#^.*<a href="\(\([^"]*/\)\?epel-release-[0-9]\+-[0-9]\+\.noarch\.rpm\)".*$#\1#p' \
  ;
)

if [[ ! $epel_release_url =~ ^https?:// ]]; then
  epel_release_url="$epel_url/repoview/$epel_release_url"
fi

rpm -iv "$epel_release_url"

sed -i.dist 's/^enabled=.*/enabled=0/' /etc/yum.repos.d/epel{,-*}.repo

