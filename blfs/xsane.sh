#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xsane:0.999

#REQ:gtk2
#REQ:sane
#OPT:lcms
#OPT:gimp


cd $SOURCE_DIR

URL=http://www.xsane.org/download/xsane-0.999.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc http://www.xsane.org/download/xsane-0.999.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e 's/png_ptr->jmpbuf/png_jmpbuf(png_ptr)/' src/xsane-save.c &&
./configure --prefix=/usr                                           &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make xsanedocdir=/usr/share/doc/xsane-0.999 install &&
ln -v -s ../../doc/xsane-0.999 /usr/share/sane/xsane/doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s <browser> /usr/bin/netscape

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s /usr/bin/xsane /usr/lib/gimp/2.0/plug-ins/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xsane=>`date`" | sudo tee -a $INSTALLED_LIST

