#!/bin/bash

set -u
set -e
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='fixedver-base' \
  fuse-libs \
  open-vm-tools \
;
