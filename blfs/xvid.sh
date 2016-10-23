#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak XviD is an MPEG-4 compliant videobr3ak CODEC.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:yasm


#VER:xvidcore:1.3.3


NAME="xvid"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.3.tar.gz || wget -nc http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xvidcore/xvidcore-1.3.3.tar.gz


URL=http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd build/generic &&
sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile &&
make install &&
chmod -v 755 /usr/lib/libxvidcore.so.4.3 &&
install -v -m755 -d /usr/share/doc/xvidcore-1.3.3/examples &&
install -v -m644 ../../doc/* /usr/share/doc/xvidcore-1.3.3 &&
install -v -m644 ../../examples/* \
    /usr/share/doc/xvidcore-1.3.3/examples

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
