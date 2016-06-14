#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gsl:2.1

#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.gnu.org/pub/gnu/gsl/gsl-2.1.tar.gz

wget -nc ftp://ftp.gnu.org/pub/gnu/gsl/gsl-2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gsl/gsl-2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gsl/gsl-2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gsl/gsl-2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsl/gsl-2.1.tar.gz || wget -nc http://ftp.gnu.org/pub/gnu/gsl/gsl-2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsl/gsl-2.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make &&
make html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir /usr/share/doc/gsl-2.1 &&
cp doc/gsl-ref.html/* /usr/share/doc/gsl-2.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gsl=>`date`" | sudo tee -a $INSTALLED_LIST

