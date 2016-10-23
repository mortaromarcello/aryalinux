#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Yelp package contains a helpbr3ak browser used for viewing help files.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gsettings-desktop-schemas
#REQ:webkitgtk
#REQ:yelp-xsl
#REC:desktop-file-utils
#OPT:gtk-doc


#VER:yelp:3.22.0


NAME="yelp"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST