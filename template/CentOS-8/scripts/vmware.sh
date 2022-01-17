#!/bin/bash

set -u
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='Kickstart-BaseOS' \
  --enablerepo='Kickstart-AppStream' \
  fuse-libs \
  open-vm-tools \
;
