#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:evolution-data-server:3.22.0

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

wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.22/evolution-data-server-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.22/evolution-data-server-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evolution-data-server/evolution-data-server-3.22.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr         \
            --disable-uoa         \
            --disable-google-auth \
            --enable-vala-bindings &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "evolution-data-server=>`date`" | sudo tee -a $INSTALLED_LIST

