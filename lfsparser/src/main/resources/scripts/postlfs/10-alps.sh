#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build.log"

export STEP_NAME="10-alps"

touch $LOG_PATH
cd $SOURCE_DIR

. /sources/build.conf

if ! grep "$STEP_NAME" $LOG_PATH
then

sudo mkdir -pv /etc/alps
sudo mkdir -pv /var/cache/alps/{sources,scripts,binaries}
sudo mkdir -pv /var/lib/alps
sudo cp -v {alps,alpsselfupdate,alpsupdate} /usr/bin
sudo cp -v alps.conf /etc/alps
sudo cp -v functions /var/lib/alps/
sudo tar xvf scripts.tar.gz -C /var/cache/alps/scripts/

sudo chmod -v 755 /usr/bin/alps*
sudo chmod -v 755 /var/cache/alps/scripts/*
sudo chown -Rv $USERNAME:$USERNAME /etc/alps
sudo chown -Rv $USERNAME:$USERNAME /var/cache/alps
touch /etc/alps/installed-list

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEP_NAME" >> $LOG_PATH

fi


