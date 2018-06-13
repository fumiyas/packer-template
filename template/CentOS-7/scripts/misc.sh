#!/bin/bash

set -u
umask 0022

systemctl disable getty@ttyS0.service
