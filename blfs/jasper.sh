#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The JasPer Project is anbr3ak open-source initiative to provide a free software-based referencebr3ak implementation of the JPEG-2000 codec.br3ak"
SECTION="general"
VERSION=1.900.5
NAME="jasper"

#REC:libjpeg
#OPT:freeglut


cd $SOURCE_DIR

URL=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.5.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jasper/jasper-1.900.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jasper/jasper-1.900.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jasper/jasper-1.900.5.tar.gz || wget -nc http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jasper/jasper-1.900.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jasper/jasper-1.900.5.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/jasper-1.900.5 &&
install -v -m644 doc/*.pdf /usr/share/doc/jasper-1.900.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
