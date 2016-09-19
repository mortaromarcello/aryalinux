#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gutenprint:5.2.11

#REC:cups
#OPT:gimp
#OPT:ijs
#OPT:imagemagick
#OPT:texlive
#OPT:tl-installer
#OPT:doxygen
#OPT:docbook-utils


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/gimp-print/gutenprint-5.2.11.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc http://downloads.sourceforge.net/gimp-print/gutenprint-5.2.11.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
       {,doc/,doc/developer/}Makefile.in &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/gutenprint-5.2.11/api/gutenprint{,ui2} &&
install -v -m644    doc/gutenprint/html/* \
                    /usr/share/doc/gutenprint-5.2.11/api/gutenprint &&
install -v -m644    doc/gutenprintui2/html/* \
                    /usr/share/doc/gutenprint-5.2.11/api/gutenprintui2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl restart org.cups.cupsd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gutenprint=>`date`" | sudo tee -a $INSTALLED_LIST

