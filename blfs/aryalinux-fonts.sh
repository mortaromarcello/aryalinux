#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://aryalinux.org/releases/2016.04/aryalinux-fonts-2016.04.tar.gz
wget -nc $URL

sudo tar xf aryalinux-fonts-2016.04.tar.gz -C /

echo "aryalinux-fonts=>`date`" | sudo tee -a $INSTALLED_LIST
