#!/bin/bash

set -u
set -e

## FIXME
el_ver="6"
if [[ $el_ver -ge 7 ]]; then
  el_arch="x86_64"
else
  el_arch="i386"
fi

epel_url_prefix="http://download.fedoraproject.org/pub/epel"
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

