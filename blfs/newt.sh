#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:newt:0.52.18

#REQ:popt
#REQ:slang
#REC:gpm
#OPT:python2
#OPT:python3


cd $SOURCE_DIR

URL=http://fedorahosted.org/releases/n/e/newt/newt-0.52.18.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/newt/newt-0.52.18.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/newt/newt-0.52.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/newt/newt-0.52.18.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/newt/newt-0.52.18.tar.gz || wget -nc http://fedorahosted.org/releases/n/e/newt/newt-0.52.18.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/newt/newt-0.52.18.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -e 's/^LIBNEWT =/#&/' \
    -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
    -e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
    -i Makefile.in                           &&
./configure --prefix=/usr --with-gpm-support &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "newt=>`date`" | sudo tee -a $INSTALLED_LIST

