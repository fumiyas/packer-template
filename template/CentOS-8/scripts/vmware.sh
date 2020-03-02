#!/bin/bash

set -u
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='FixedVer-BaseOS' \
  --enablerepo='FixedVer-AppStream' \
  fuse-libs \
  open-vm-tools \
;
