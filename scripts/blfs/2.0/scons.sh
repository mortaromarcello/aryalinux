#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/scons/scons-2.3.4.tar.gz


TARBALL=scons-2.3.4.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998778.sh << "ENDOFFILE"
python setup.py install --prefix=/usr  \
                        --standard-lib \
                        --optimize=1   \
                        --install-data=/usr/share
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "scons=>`date`" | sudo tee -a $INSTALLED_LIST