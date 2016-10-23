#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The UDisks package provides abr3ak daemon, tools and libraries to access and manipulate disks andbr3ak storage devices.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libatasmart
#REQ:libgudev
#REQ:libxslt
#REQ:polkit
#REC:systemd
#OPT:gobject-introspection
#OPT:gptfdisk
#OPT:gtk-doc
#OPT:ntfs-3g
#OPT:parted


#VER:udisks:2.1.7


NAME="udisks2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc http://udisks.freedesktop.org/releases/udisks-2.1.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2


URL=http://udisks.freedesktop.org/releases/udisks-2.1.7.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static &&
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
