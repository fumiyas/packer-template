#!/bin/bash

set -u
set -e
umask 0022

dnf install \
  --assumeyes \
  --setopt=install_weak_deps=False \
  --disablerepo='*' \
  --enablerepo='kickstart-baseos' \
  --enablerepo='kickstart-appstream' \
  fuse-libs \
  open-vm-tools \
;
