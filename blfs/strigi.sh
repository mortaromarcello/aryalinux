#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:strigi:0.7.8

#REQ:cmake
#REC:dbus
#REC:qt4
#OPT:ffmpeg
#OPT:exiv2
#OPT:libxml2


cd $SOURCE_DIR

URL=http://www.vandenoever.info/software/strigi/strigi-0.7.8.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/strigi/strigi-0.7.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/strigi/strigi-0.7.8.tar.bz2 || wget -nc http://www.vandenoever.info/software/strigi/strigi-0.7.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/strigi/strigi-0.7.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/strigi/strigi-0.7.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/strigi/strigi-0.7.8.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "s/BufferedStream :/STREAMS_EXPORT &/" libstreams/include/strigi/bufferedstream.h &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -DCMAKE_BUILD_TYPE=Release  \
      -DENABLE_CLUCENE=OFF        \
      -DENABLE_CLUCENE_NG=OFF     \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "strigi=>`date`" | sudo tee -a $INSTALLED_LIST

