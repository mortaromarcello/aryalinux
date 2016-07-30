#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:clutter-gst:2.0.14

cd $SOURCE_DIR

URL="http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz"
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "clutter-gst2=>`date`" | sudo tee -a $INSTALLED_LIST
