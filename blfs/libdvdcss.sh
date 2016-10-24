#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak libdvdcss is a simple librarybr3ak designed for accessing DVDs as a block device without having tobr3ak bother about the decryption.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:doxygen


#VER:libdvdcss:1.4.0


NAME="libdvdcss"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://download.videolan.org/libdvdcss/1.4.0/libdvdcss-1.4.0.tar.bz2


URL=http://download.videolan.org/libdvdcss/1.4.0/libdvdcss-1.4.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libdvdcss-1.4.0 &&
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
