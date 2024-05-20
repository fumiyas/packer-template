#!/bin/bash

set -u
set -e
umask 0022

rm /etc/ssh/sshd_config.d/00-packer.conf

mkdir -p /etc/skel/.ssh
cp /dev/null /etc/skel/.ssh/authorized_keys
