#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:screen:4.4.0

#OPT:linux-pam


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz || wget -nc https://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                     \
            --infodir=/usr/share/info         \
            --mandir=/usr/share/man           \
            --with-socket-dir=/run/screen     \
            --with-pty-group=5                \
            --with-sys-screenrc=/etc/screenrc &&
sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/* &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -m 644 etc/etcscreenrc /etc/screenrc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "screen=>`date`" | sudo tee -a $INSTALLED_LIST

