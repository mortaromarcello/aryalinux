#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Desktop File Utils packagebr3ak contains command line utilities for working with <a class="ulink" br3ak href="http://standards.freedesktop.org/desktop-entry-spec/latest/">Desktopbr3ak entries</a>. These utilities are used by Desktop Environments andbr3ak other applications to manipulate the MIME-types applicationbr3ak databases and help adhere to the Desktop Entry Specification.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#OPT:emacs


#VER:desktop-file-utils:0.23


NAME="desktop-file-utils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz


URL=http://freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
