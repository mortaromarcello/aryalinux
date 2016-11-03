#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXSession package contains thebr3ak default session manager for LXDE.br3ak"
SECTION="lxde"
VERSION=0.5.2
NAME="lxsession"

#REQ:dbus-glib
#REQ:libunique
#REQ:lsb-release
#REQ:polkit
#REQ:vala
#OPT:gtk3
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lxde/lxsession-0.5.2.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxsession-0.5.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz

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

./configure --prefix=/usr --disable-man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
