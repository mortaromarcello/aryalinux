#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libnl suite is a collection ofbr3ak libraries providing APIs to netlink protocol based Linux kernelbr3ak interfaces.br3ak"
SECTION="basicnet"
VERSION=3.2.28
NAME="libnl"

#OPT:check


cd $SOURCE_DIR

URL=https://github.com/thom311/libnl/releases/download/libnl3_2_28/libnl-3.2.28.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/thom311/libnl/releases/download/libnl3_2_28/libnl-3.2.28.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnl/libnl-3.2.28.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc https://github.com/thom311/libnl/releases/download/libnl3_2_28/libnl-doc-3.2.28.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-doc-3.2.28.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`" || make



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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
