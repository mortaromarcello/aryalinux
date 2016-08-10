#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:totem-pl-parser:3.10.6

#REQ:gmime
#REQ:libsoup
#REC:gobject-introspection
#REC:libarchive
#REC:libgcrypt
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.6.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.6.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"


sed -e '/g_test_add_func (\"\/parser\/parsability/d' \
    -e '/g_test_add_func (\"\/parser\/parsing\/xml_mixed_cdata/d' \
    -i plparse/tests/parser.c



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "totem-pl-parser=>`date`" | sudo tee -a $INSTALLED_LIST

