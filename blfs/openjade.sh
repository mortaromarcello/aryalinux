#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:openjade:1.3.2

#REQ:opensp


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc http://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/openjade-1.3.2-gcc_4.6-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openjade/openjade-1.3.2-gcc_4.6-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../openjade-1.3.2-gcc_4.6-1.patch


sed -i -e '/getopts/{N;s#&G#g#;s#do .getopts.pl.;##;}' \
       -e '/use POSIX/ause Getopt::Std;' msggen.pl


./configure --prefix=/usr                                \
            --mandir=/usr/share/man                      \
            --enable-http                                \
            --disable-static                             \
            --enable-default-catalog=/etc/sgml/catalog   \
            --enable-default-search-path=/usr/share/sgml \
            --datadir=/usr/share/sgml/openjade-1.3.2   &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                                   &&
make install-man                                               &&
ln -v -sf openjade /usr/bin/jade                               &&
ln -v -sf libogrove.so /usr/lib/libgrove.so                    &&
ln -v -sf libospgrove.so /usr/lib/libspgrove.so                &&
ln -v -sf libostyle.so /usr/lib/libstyle.so                    &&
install -v -m644 dsssl/catalog /usr/share/sgml/openjade-1.3.2/ &&
install -v -m644 dsssl/*.{dtd,dsl,sgm}              \
    /usr/share/sgml/openjade-1.3.2                             &&
install-catalog --add /etc/sgml/openjade-1.3.2.cat  \
    /usr/share/sgml/openjade-1.3.2/catalog                     &&
install-catalog --add /etc/sgml/sgml-docbook.cat    \
    /etc/sgml/openjade-1.3.2.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "SYSTEM \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" \
    \"/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd\"" >> \
    /usr/share/sgml/openjade-1.3.2/catalog

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openjade=>`date`" | sudo tee -a $INSTALLED_LIST

