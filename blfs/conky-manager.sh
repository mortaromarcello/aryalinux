#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:conky:svn

#REQ:conky
#REQ:json-glib
#REQ:rsync
#REQ:p7zip-full

cd $SOURCE_DIR

wget aryalinux.org/releases/2016.04/conky-manager.tar.gz

sudo tar xf conky-manager.tar.gz -C /

cd $SOURCE_DIR
rm -rf conky

echo "conky-manager=>`date`" | sudo tee -a $INSTALLED_LIST


