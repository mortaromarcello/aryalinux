#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lsb-release:1.4



cd $SOURCE_DIR

URL=http://sourceforge.net/projects/lsb/files/lsb_release/1.4/lsb-release-1.4.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc http://sourceforge.net/projects/lsb/files/lsb_release/1.4/lsb-release-1.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i "s|n/a|unavailable|" lsb_release


./help2man -N --include ./lsb_release.examples \
              --alt_version_key=program_version ./lsb_release > lsb_release.1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 644 lsb_release.1 /usr/share/man/man1/lsb_release.1 &&
install -v -m 755 lsb_release /usr/bin/lsb_release

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lsb-release=>`date`" | sudo tee -a $INSTALLED_LIST

