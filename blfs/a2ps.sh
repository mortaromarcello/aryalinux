#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:i18n-fonts:0.1
#VER:a2ps:4.14

#REC:psutils
#REC:cups
#OPT:gs
#OPT:libpaper
#OPT:texlive
#OPT:tl-installer
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/i18n-fonts/i18n-fonts-0.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/i18n-fonts/i18n-fonts-0.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/i18n-fonts/i18n-fonts-0.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/i18n-fonts/i18n-fonts-0.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/i18n-fonts/i18n-fonts-0.1.tar.bz2 || wget -nc http://anduin.linuxfromscratch.org/BLFS/i18n-fonts/i18n-fonts-0.1.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/a2ps/a2ps-4.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/a2ps/a2ps-4.14.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/a2ps/a2ps-4.14.tar.gz || wget -nc http://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/a2ps/a2ps-4.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/a2ps/a2ps-4.14.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

autoconf &&
sed -i -e "s/GPERF --version |/& head -n 1 |/" \
       -e "s|/usr/local/share|/usr/share|" configure &&
./configure --prefix=/usr  \
    --sysconfdir=/etc/a2ps \
    --enable-shared        \
    --with-medium=letter   &&
make                       &&
touch doc/*.info



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../i18n-fonts-0.1.tar.bz2 &&
cp -v i18n-fonts-0.1/fonts/* /usr/share/a2ps/fonts               &&
cp -v i18n-fonts-0.1/afm/* /usr/share/a2ps/afm                   &&
pushd /usr/share/a2ps/afm    &&
  ./make_fonts_map.sh        &&
  mv fonts.map.new fonts.map &&
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "a2ps=>`date`" | sudo tee -a $INSTALLED_LIST

