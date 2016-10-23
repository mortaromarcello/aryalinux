#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The VTE package contains a termcapbr3ak file implementation for terminal emulators.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gtk3
#REQ:libxml2
#REQ:pcre2
#REC:gobject-introspection
#OPT:gnutls
#OPT:gtk-doc
#OPT:vala


#VER:vte:0.46.0


NAME="vte"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.46.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vte/vte-0.46.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.46/vte-0.46.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.46.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.46.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.46/vte-0.46.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.46.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.46/vte-0.46.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/Werror/d' configure.ac &&
autoreconf                      &&
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-static       \
            --enable-introspection &&
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