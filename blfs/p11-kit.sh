#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:p11-kit:0.23.2

#REC:cacerts
#REC:libtasn1
#REC:libffi
#OPT:nss
#OPT:gtk-doc
#OPT:libxslt


cd $SOURCE_DIR

URL=http://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc http://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "p11-kit=>`date`" | sudo tee -a $INSTALLED_LIST

