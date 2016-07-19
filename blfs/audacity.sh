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

./configure --prefix=/usr  --disable-dynamic-loading --with-ffmpeg=system
sudo mv /usr/lib/libvamp-hostsdk.la .
make "-j`nproc`"
sudo mv ./libvamp-hostsdk.la /usr/lib/
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "audacity=>`date`" | sudo tee -a $INSTALLED_LIST
