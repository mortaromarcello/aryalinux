#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The DocBook SGML DTD packagebr3ak contains document type definitions for verification of SGML databr3ak files against the DocBook rule set. These are useful forbr3ak structuring books and software documentation to a standard allowingbr3ak you to utilize transformations already written for that standard.br3ak
#SECTION:pst

#REQ:sgml-common
#REQ:unzip


#VER:docbk:31


NAME="sgml-dtd-3"

wget -nc ftp://ftp.kde.org/pub/kde/devel/docbook/SOURCES/docbk31.zip || wget -nc http://www.docbook.org/sgml/3.1/docbk31.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbk/docbk31.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbk/docbk31.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbk/docbk31.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbk/docbk31.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbk/docbk31.zip


URL=http://www.docbook.org/sgml/3.1/docbk31.zip
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
