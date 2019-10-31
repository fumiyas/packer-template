#!/bin/bash

set -u
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='base' \
  fuse-libs \
  open-vm-tools \
;
