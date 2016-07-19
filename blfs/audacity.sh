#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:audacity_.orig:2.1.2


#REQ:audio-video-plugins
#REQ:ffmpeg
#REQ:vamp-plugin-sdk
#REQ:wxwidgets

URL=http://archive.ubuntu.com/ubuntu/pool/universe/a/audacity/audacity_2.1.2.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

sudo rm -vf /usr/lib64/libvamp-hostsdk.la
./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "audacity=>`date`" | sudo tee -a $INSTALLED_LIST
