#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xarchiver:0.5.4

#REQ:gtk2
#REQ:gtk3
#OPT:cpio
#OPT:lzo
#OPT:p7zip
#OPT:unrar
#OPT:unzip
#OPT:zip


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/project/xarchiver/xarchiver-0.5.4.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/xarchiver-0.5.4-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xarchiver/xarchiver-0.5.4-fixes-1.patch
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://downloads.sourceforge.net/project/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../xarchiver-0.5.4-fixes-1.patch &&
./autogen.sh --prefix=/usr               \
             --libexecdir=/usr/lib/xfce4 \
             --disable-gtk3              \
             --docdir=/usr/share/doc/xarchiver-0.5.4 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DOCDIR=/usr/share/doc/xarchiver-0.5.4 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xarchiver=>`date`" | sudo tee -a $INSTALLED_LIST

