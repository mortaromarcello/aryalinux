#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/traceroute/traceroute-2.0.21.tar.gz


TARBALL=traceroute-2.0.21.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make

cat > 1434987998783.sh << "ENDOFFILE"
make prefix=/usr install                               &&
mv /usr/bin/traceroute /bin                            &&
ln -sfv traceroute /bin/traceroute6                    &&
ln -sfv traceroute.8 /usr/share/man/man8/traceroute6.8 &&
rm -fv /usr/share/man/man1/traceroute.1
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "traceroute=>`date`" | sudo tee -a $INSTALLED_LIST