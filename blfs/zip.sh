#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Zip package containsbr3ak Zip utilities. These are usefulbr3ak for compressing files into <code class="filename">ZIPbr3ak archives.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:zip:30


NAME="zip"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/infozip/zip30.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zip/zip30.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zip/zip30.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz


URL=http://downloads.sourceforge.net/infozip/zip30.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make -f unix/Makefile generic_gcc



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
