#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnumeric:1.12.27

#REQ:goffice010
#REQ:rarian
#REC:adwaita-icon-theme
#REC:oxygen-icons
#REC:yelp
#REC:xorg-server
#OPT:dconf
#OPT:gobject-introspection
#OPT:python-modules#pygobject3
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.27.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnumeric/gnumeric-1.12.27.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.27.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.27.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.27.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.27.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.27.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.27.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e "s@zz-application/zz-winassoc-xls;@@" \
    -i gnumeric.desktop.in &&
./configure --prefix=/usr  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed \
  -e '/\tt6500-strings.*/d;/\tt6506-cell-comments.*/d;/\tt6509-validation.*/d' \
  -i test/Makefile


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnumeric=>`date`" | sudo tee -a $INSTALLED_LIST

