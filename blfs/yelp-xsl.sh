#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Yelp XSL package contains XSLbr3ak stylesheets that are used by the Yelp help browser to format Docbook andbr3ak Mallard documents.br3ak"
SECTION="gnome"
VERSION=3.20.1
NAME="yelp-xsl"

#REQ:libxslt
#REQ:itstool


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/yelp-xsl/3.20/yelp-xsl-3.20.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yelp-xsl/yelp-xsl-3.20.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/yelp-xsl/3.20/yelp-xsl-3.20.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yelp-xsl/yelp-xsl-3.20.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yelp-xsl/yelp-xsl-3.20.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/yelp-xsl/3.20/yelp-xsl-3.20.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp-xsl/yelp-xsl-3.20.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp-xsl/yelp-xsl-3.20.1.tar.xz

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
