#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libiodbc is an API to ODBCbr3ak compatible databases.br3ak
#SECTION:general

#REC:gtk2


#VER:libiodbc:3.52.12


NAME="libiodbc"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc http://downloads.sourceforge.net/project/iodbc/iodbc/3.52.12/libiodbc-3.52.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz


URL=http://downloads.sourceforge.net/project/iodbc/iodbc/3.52.12/libiodbc-3.52.12.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr                   \
            --with-iodbc-inidir=/etc/iodbc  \
            --includedir=/usr/include/iodbc \
            --disable-libodbc               \
            --disable-static                &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
