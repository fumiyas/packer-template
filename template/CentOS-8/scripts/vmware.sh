#!/bin/bash

set -u
set -e
umask 0022

yum -y install \
  --disablerepo='*' \
  --enablerepo='kickstart-baseos' \
  --enablerepo='kickstart-appstream' \
  fuse-libs \
  open-vm-tools \
;
