#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://sourceforge.net/projects/lsb/files/lsb_release/1.4/lsb-release-1.4.tar.gz


TARBALL=lsb-release-1.4.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s|n/a|unavailable|" lsb_release

./help2man -N --include ./lsb_release.examples \
              --alt_version_key=program_version ./lsb_release > lsb_release.1

cat > 1434987998744.sh << "ENDOFFILE"
install -v -m 644 lsb_release.1 /usr/share/man/man1/lsb_release.1 &&
install -v -m 755 lsb_release /usr/bin/lsb_release
ENDOFFILE
chmod a+x 1434987998744.sh
sudo ./1434987998744.sh
sudo rm -rf 1434987998744.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lsb-release=>`date`" | sudo tee -a $INSTALLED_LIST