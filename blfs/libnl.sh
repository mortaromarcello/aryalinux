#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libnl suite is a collection ofbr3ak libraries providing APIs to netlink protocol based Linux kernelbr3ak interfaces.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#OPT:check


#VER:libnl:3.2.28
#VER:libnl-doc:3.2.28


NAME="libnl"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://github.com/thom311/libnl/releases/download/libnl3_2_28/libnl-3.2.28.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc https://github.com/thom311/libnl/releases/download/libnl3_2_28/libnl-doc-3.2.28.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz


URL=https://github.com/thom311/libnl/releases/download/libnl3_2_28/libnl-3.2.28.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -vp /usr/share/doc/libnl-3.2.28 &&
tar -xf ../libnl-doc-3.2.28.tar.gz --strip-components=1 --no-same-owner \
    -C  /usr/share/doc/libnl-3.2.28

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
