#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Shared Mime Info packagebr3ak contains a MIME database. This allows central updates of MIMEbr3ak information for all supporting applications.br3ak"
SECTION="general"
VERSION=1.7
NAME="shared-mime-info"

#REQ:glib2
#REQ:libxml2


cd $SOURCE_DIR

URL=http://freedesktop.org/~hadess/shared-mime-info-1.7.tar.xz

if [ ! -z $URL ]
then
wget -nc http://freedesktop.org/~hadess/shared-mime-info-1.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/shared-mime-info/shared-mime-info-1.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.7.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
