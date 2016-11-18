#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The NcFTP package contains abr3ak powerful and flexible interface to the Internet standard Filebr3ak Transfer Protocol. It is intended to replace or supplement thebr3ak stock <span class=\"command\"><strong>ftp</strong> program.br3ak"
SECTION="basicnet"
VERSION=3.2.5
NAME="ncftp"



cd $SOURCE_DIR

URL=ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2

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

./configure --prefix=/usr --sysconfdir=/etc &&
make -C libncftp shared &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C libncftp soinstall &&
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
