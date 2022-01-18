#!/bin/bash

set -u
set -e
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='FixedVer-base' \
  fuse-libs \
  open-vm-tools \
;
