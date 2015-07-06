#!/bin/bash

set -e
set +h

read -p "Enter root partition : " ROOT_PART
read -p "Enter home partition : " HOME_PART
read -p "Enter swap Partition : " SWAP_PART

cat > inputs <<EOF
ROOT_PART=$ROOT_PART
SWAP_PART=$SWAP_PART
HOME_PART=$HOME_PART
EOF

export CLFS=/mnt/clfs

mkfs.ext4 $ROOT_PART

mkdir -pv ${CLFS}
mount -v $ROOT_PART ${CLFS}

cp -rf ../sources $CLFS/
chmod -v a+wt ${CLFS}/sources

install -dv ${CLFS}/tools
ln -sv ${CLFS}/tools /

install -dv ${CLFS}/cross-tools
ln -sv ${CLFS}/cross-tools /

groupadd clfs
useradd -s /bin/bash -g clfs -d /home/clfs clfs
mkdir -pv /home/clfs
chown -v clfs:clfs /home/clfs

passwd clfs

chown -v clfs ${CLFS}/tools
chown -v clfs ${CLFS}/cross-tools
chown -v clfs ${CLFS}/sources

cp -rf * /home/clfs
chown -R clfs:clfs /home/clfs

su - clfs
