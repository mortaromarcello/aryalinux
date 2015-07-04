#!/bin/bash

set -e
set +h

export CLFS=/mnt/clfs

export CLFS_HOST=$(echo ${MACHTYPE} | sed -e 's/-[^-]*/-cross/')
export CLFS_TARGET="x86_64-unknown-linux-gnu"
export BUILD64="-m64"

cat >> ~/.bashrc << EOF
export CLFS_HOST="${CLFS_HOST}"
export CLFS_TARGET="${CLFS_TARGET}"
export BUILD64="${BUILD64}"
EOF


for script in cross-tools/*
do
	$script
done
