#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gutenprint (formerlybr3ak Gimp-Print) package contains highbr3ak quality drivers for many brands and models of printers for use withbr3ak <a class="xref" href="gs.html" title="ghostscript-9.20">ghostscript-9.20</a>, <a class="xref" href="cups.html" title="Cups-2.2.1">Cups-2.2.1</a>, <a class="ulink" br3ak href="http://www.linuxfoundation.org/collaborate/workgroups/openprinting/database/foomatic">br3ak Foomatic</a>, and the GIMP-2.0.br3ak See a list of supported printers at <a class="ulink" href="http://gutenprint.sourceforge.net/p_Supported_Printers.php">http://gutenprint.sourceforge.net/p_Supported_Printers.php</a>.br3ak
#SECTION:pst

whoami > /tmp/currentuser

#REC:cups
#REC:gimp
#OPT:ijs
#OPT:imagemagick
#OPT:texlive
#OPT:tl-installer
#OPT:doxygen
#OPT:docbook-utils


#VER:gutenprint:5.2.11


NAME="gutenprint"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2 || wget -nc http://downloads.sourceforge.net/gimp-print/gutenprint-5.2.11.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.11.tar.bz2


URL=http://downloads.sourceforge.net/gimp-print/gutenprint-5.2.11.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
       {,doc/,doc/developer/}Makefile.in &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



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
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
