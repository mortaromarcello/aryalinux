#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libao:1.2.0

#OPT:pulseaudio
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 README /usr/share/doc/libao-1.2.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libao=>`date`" | sudo tee -a $INSTALLED_LIST

