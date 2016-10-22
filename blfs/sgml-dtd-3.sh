#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:docbk:31

#REQ:sgml-common
#REQ:unzip


cd $SOURCE_DIR

URL=http://www.docbook.org/sgml/3.1/docbk31.zip

wget -nc ftp://ftp.kde.org/pub/kde/devel/docbook/SOURCES/docbk31.zip || wget -nc http://www.docbook.org/sgml/3.1/docbk31.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbk/docbk31.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbk/docbk31.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbk/docbk31.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbk/docbk31.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbk/docbk31.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=''
unzip_dirname $TARBALL DIRECTORY

unzip_file $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e '/ISO 8879/d' \
       -e 's|DTDDECL "-//OASIS//DTD DocBook V3.1//EN"|SGMLDECL|g' \
       docbook.cat



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/sgml/docbook/sgml-dtd-3.1 &&
chown -R root:root . &&
install -v docbook.cat /usr/share/sgml/docbook/sgml-dtd-3.1/catalog &&
cp -v -af *.dtd *.mod *.dcl /usr/share/sgml/docbook/sgml-dtd-3.1 &&
install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
    /usr/share/sgml/docbook/sgml-dtd-3.1/catalog &&
install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
    /etc/sgml/sgml-docbook.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /usr/share/sgml/docbook/sgml-dtd-3.1/catalog << "EOF"
 -- Begin Single Major Version catalog changes --
PUBLIC "-//Davenport//DTD DocBook V3.0//EN" "docbook.dtd"
 -- End Single Major Version catalog changes --
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sgml-dtd-3=>`date`" | sudo tee -a $INSTALLED_LIST

