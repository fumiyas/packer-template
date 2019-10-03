#!/bin/bash

set -u
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='BaseOS' \
  --enablerepo='AppStream' \
  fuse-libs \
  open-vm-tools \
;
