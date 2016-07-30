#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fontconfig:2.12.0

#REQ:freetype2
#OPT:docbook-utils
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fontconfig/fontconfig-2.12.0.tar.bz2 || wget -nc http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.12.0 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 \
        /usr/share/{man/man{3,5},doc/fontconfig-2.12.0/fontconfig-devel} &&
install -v -m644 fc-*/*.1         /usr/share/man/man1 &&
install -v -m644 doc/*.3          /usr/share/man/man3 &&
install -v -m644 doc/fonts-conf.5 /usr/share/man/man5 &&
install -v -m644 doc/fontconfig-devel/* \
                                  /usr/share/doc/fontconfig-2.12.0/fontconfig-devel &&
install -v -m644 doc/*.{pdf,sgml,txt,html} \
                                  /usr/share/doc/fontconfig-2.12.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "fontconfig=>`date`" | sudo tee -a $INSTALLED_LIST

