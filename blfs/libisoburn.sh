#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libisoburn is a frontend forbr3ak libraries libburn and libisofs which enables creation and expansionbr3ak of ISO-9660 filesystems on all CD/DVD/BD media supported bybr3ak libburn. This includes media likebr3ak DVD+RW, which do not support multi-session management on mediabr3ak level and even plain disk files or block devices.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:libburn
#REQ:libisofs


#VER:libisoburn:1.4.6


NAME="libisoburn"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libisoburn/libisoburn-1.4.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.6.tar.gz || wget -nc http://files.libburnia-project.org/releases/libisoburn-1.4.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.6.tar.gz


URL=http://files.libburnia-project.org/releases/libisoburn-1.4.6.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr              \
            --disable-static           \
            --enable-pkg-check-modules &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
