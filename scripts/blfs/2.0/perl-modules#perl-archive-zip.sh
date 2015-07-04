#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.45.tar.gz


TARBALL=Archive-Zip-1.45.tar.gz
DIRECTORY=Archive-Zip-1.45

tar -xf $TARBALL

cd $DIRECTORY

perl Makefile.PL &&
make

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "perl-modules#perl-archive-zip=>`date`" | sudo tee -a $INSTALLED_LIST