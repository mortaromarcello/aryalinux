#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Speex is an audio compressionbr3ak format designed especially for speech. It is well-adapted tobr3ak internet applications and provides useful features that are notbr3ak present in most other CODECs.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:libogg
#OPT:valgrind


#VER:speex-1.rc:2
#VER:speexdsp-1.2rc:3


NAME="speex"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz || wget -nc http://downloads.us.xiph.org/releases/speex/speex-1.2rc2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speex-1.2rc2.tar.gz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://downloads.us.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz


URL=http://downloads.us.xiph.org/releases/speex/speex-1.2rc2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speex-1.2rc2 &&
make "-j`nproc`" || make



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
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
