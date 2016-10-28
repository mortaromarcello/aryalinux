#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak XArchiver is a GTK+ archive manager with support for tar, xz,br3ak bzip2, gzip, zip, 7z, rar, lzo and many other archive formats.br3ak
#SECTION:xsoft

#REQ:gtk2
#REQ:gtk3
#OPT:cpio
#OPT:lzo
#OPT:p7zip
#OPT:unrar
#OPT:unzip
#OPT:zip


#VER:xarchiver:0.5.4


NAME="xarchiver"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://downloads.sourceforge.net/project/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xarchiver-0.5.4-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xarchiver/xarchiver-0.5.4-fixes-1.patch


URL=http://downloads.sourceforge.net/project/xarchiver/xarchiver-0.5.4.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../xarchiver-0.5.4-fixes-1.patch &&

./autogen.sh --prefix=/usr               \
             --libexecdir=/usr/lib/xfce4 \
             --disable-gtk3              \
             --docdir=/usr/share/doc/xarchiver-0.5.4 &&
make


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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
