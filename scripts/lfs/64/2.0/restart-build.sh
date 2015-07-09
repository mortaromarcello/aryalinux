#!/bin/bash

umount /mnt/clfs
rm -rf /mnt/clfs
rm -rf /cross-tools
rm -rf /tools
userdel -r clfs

