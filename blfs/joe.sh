#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak JOE (Joe's own editor) is a smallbr3ak text editor capable of emulating WordStar, Pico, and Emacs.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser



#VER:joe:4.3


NAME="joe"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/joe/joe-4.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/joe/joe-4.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/joe/joe-4.3.tar.gz || wget -nc http://downloads.sourceforge.net/joe-editor/joe-4.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/joe/joe-4.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/joe/joe-4.3.tar.gz


URL=http://downloads.sourceforge.net/joe-editor/joe-4.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/joe-4.3 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vm 755 joe/util/{stringify,termidx,uniproc} /usr/bin &&
install -vdm755 /usr/share/joe/util &&
install -vm 644 joe/util/{*.txt,README} /usr/share/joe/util

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
