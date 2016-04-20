#!/bin/bash

set -u
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='base' \
  fuse-libs \
;

yum -y install \
  --disablerepo='*' \
  --enablerepo='base,epel' \
  open-vm-tools \
;

