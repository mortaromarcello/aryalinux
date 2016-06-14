#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dejagnu:1.5.3

#REQ:expect
#OPT:docbook-utils


cd $SOURCE_DIR

URL=https://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.5.3.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dejagnu/dejagnu-1.5.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dejagnu/dejagnu-1.5.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dejagnu/dejagnu-1.5.3.tar.gz || wget -nc ftp://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.5.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dejagnu/dejagnu-1.5.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dejagnu/dejagnu-1.5.3.tar.gz || wget -nc https://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.5.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi &&
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755   /usr/share/doc/dejagnu-1.5.3 &&
install -v -m644    doc/dejagnu.{html,txt} \
                    /usr/share/doc/dejagnu-1.5.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "dejagnu=>`date`" | sudo tee -a $INSTALLED_LIST

