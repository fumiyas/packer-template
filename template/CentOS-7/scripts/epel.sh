#!/bin/bash
##
## Extra Packages for Enterprise Linux (EPEL) repository
##

set -u
set -e

if ! rpm --query epel-release >/dev/null; then
  yum install \
    --assumeyes \
    --disablerepo='*' \
    --enablerepo='fixedver-extras' \
    epel-release \
  ;
fi

mkdir -p /etc/yum.repos.d/dist

for repo in /etc/yum.repos.d/epel{,-*}.repo; do
  repo_dist="/etc/yum.repos.d/dist/${repo##*/}"

  if [[ ! -f $repo_dist ]]; then
    cp -a "$repo" "$repo_dist"
  fi

  sed \
    -e '/^enabled=/d' \
    -e 's/^gpgcheck=.*/&\nenabled=0/' \
    <"$repo_dist" \
    >"$repo" \
  ;
done
