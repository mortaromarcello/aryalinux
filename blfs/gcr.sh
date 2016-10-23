#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gcr package contains librariesbr3ak used for displaying certificates and accessing key stores. It alsobr3ak provides the viewer for crypto files on the GNOME Desktop.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

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


#VER:gcr:3.20.0


NAME="gcr"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/gcr/3.20/gcr-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gcr/3.20/gcr-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcr/gcr-3.20.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gcr/3.20/gcr-3.20.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
