#!/bin/bash

set -u
umask 0022

yum clean all --enablerepo='*'
