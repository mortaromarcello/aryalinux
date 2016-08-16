#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:x264-snapshot-20160220-stable:2245

#REC:yasm


cd $SOURCE_DIR

URL=http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20160220-2245-stable.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x264/x264-snapshot-20160220-2245-stable.tar.bz2 || wget -nc http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20160220-2245-stable.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x264/x264-snapshot-20160220-2245-stable.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x264/x264-snapshot-20160220-2245-stable.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x264/x264-snapshot-20160220-2245-stable.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x264/x264-snapshot-20160220-2245-stable.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --enable-shared \
            --disable-cli &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "x264=>`date`" | sudo tee -a $INSTALLED_LIST

