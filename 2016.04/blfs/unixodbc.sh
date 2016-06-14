#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:unixODBC:2.3.4

#OPT:pth


cd $SOURCE_DIR

URL=ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc/unixODBC &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find doc -name "Makefile*" -delete                &&
chmod 644 doc/{lst,ProgrammerManual/Tutorial}/*   &&
install -v -m755 -d /usr/share/doc/unixODBC-2.3.4 &&
cp      -v -R doc/* /usr/share/doc/unixODBC-2.3.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "unixodbc=>`date`" | sudo tee -a $INSTALLED_LIST

