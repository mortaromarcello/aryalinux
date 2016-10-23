#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Imlib2 is a graphics library forbr3ak fast file loading, saving, rendering and manipulation.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:x7lib
#OPT:libpng
#OPT:libjpeg
#OPT:libtiff
#OPT:giflib


#VER:imlib2:1.4.9


NAME="imlib2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/imlib/imlib2-1.4.9.tar.bz2 || wget -nc http://sourceforge.net/projects/enlightenment/files/imlib2-src/1.4.9/imlib2-1.4.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/imlib/imlib2-1.4.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/imlib/imlib2-1.4.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/imlib/imlib2-1.4.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/imlib/imlib2-1.4.9.tar.bz2


URL=http://sourceforge.net/projects/enlightenment/files/imlib2-src/1.4.9/imlib2-1.4.9.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/imlib2-1.4.9 &&
install -v -m644    doc/{*.gif,index.html} \
                    /usr/share/doc/imlib2-1.4.9

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
