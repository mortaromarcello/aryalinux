#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gcr:3.20.0

#REQ:glib2
#REQ:libgcrypt
#REQ:libtasn1
#REQ:p11-kit
#REC:gnupg
#REC:gobject-introspection
#REC:gtk3
#REC:libxslt
#REC:vala
#OPT:gtk-doc
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gcr/3.20/gcr-3.20.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gcr/3.20/gcr-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gcr/3.20/gcr-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&
./configure --prefix=/usr     \
            --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gcr=>`date`" | sudo tee -a $INSTALLED_LIST

