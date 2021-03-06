#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Evolution Data Server packagebr3ak provides a unified backend for programs that work with contacts,br3ak tasks, and calendar information. It was originally developed forbr3ak Evolution (hence the name), but isbr3ak now used by other packages as well.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="evolution-data-server"

#REQ:db
#REQ:gcr
#REQ:libical
#REQ:libsecret
#REQ:libsoup
#REQ:nss
#REQ:python2
#REQ:sqlite
#REC:gnome-online-accounts
#REC:gobject-introspection
#REC:gtk3
#REC:icu
#REC:libgdata
#REC:libgweather
#REC:vala
#OPT:gtk-doc
#OPT:mitkrb
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.22/evolution-data-server-3.22.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.22/evolution-data-server-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.22/evolution-data-server-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr         \
            --disable-uoa         \
            --disable-google-auth \
            --enable-vala-bindings &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
