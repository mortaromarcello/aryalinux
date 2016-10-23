#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The UnZip package containsbr3ak <code class="filename">ZIP extraction utilities. These arebr3ak useful for extracting files from <code class="filename">ZIPbr3ak archives. <code class="filename">ZIP archives are createdbr3ak with PKZIP or Info-ZIP utilities, primarily in a DOSbr3ak environment.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:unzip:60


NAME="unzip"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unzip/unzip60.tar.gz


URL=http://downloads.sourceforge.net/infozip/unzip60.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

make -f unix/Makefile generic



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST