#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:speexdsp-1.2rc:3
#VER:speex-1.rc:2

#REQ:libogg
#OPT:valgrind


cd $SOURCE_DIR

URL=http://downloads.us.xiph.org/releases/speex/speex-1.2rc2.tar.gz

wget -nc http://downloads.us.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc http://downloads.us.xiph.org/releases/speex/speex-1.2rc2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speex-1.2rc2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd ..                          &&
tar -xf speexdsp-1.2rc3.tar.gz &&
cd speexdsp-1.2rc3             &&
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2rc3 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "speex=>`date`" | sudo tee -a $INSTALLED_LIST

