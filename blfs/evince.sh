#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Evince is a document viewer forbr3ak multiple document formats. It supports PDF, Postscript, DjVu, TIFFbr3ak and DVI. It is useful for viewing documents of various types usingbr3ak one simple application instead of the multiple document viewersbr3ak that once existed on the GNOMEbr3ak Desktop.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:libxml2
#REC:gnome-keyring
#REC:gobject-introspection
#REC:libsecret
#REC:nautilus
#REC:poppler
#OPT:cups
#OPT:gnome-desktop
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libtiff
#OPT:texlive
#OPT:tl-installer


#VER:evince:3.22.0


NAME="evince"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evince/evince-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.22/evince-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.22/evince-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/evince/3.22/evince-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                     \
            --enable-compile-warnings=minimum \
            --enable-introspection            \
            --disable-static                  &&
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