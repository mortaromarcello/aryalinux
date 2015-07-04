#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:popt
#DEP:slang
#DEP:gpm


cd $SOURCE_DIR

wget -nc http://fedorahosted.org/releases/n/e/newt/newt-0.52.18.tar.gz


TARBALL=newt-0.52.18.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e 's/^LIBNEWT =/#&/' \
    -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
    -e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
    -i Makefile.in                           &&
./configure --prefix=/usr --with-gpm-support &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "newt=>`date`" | sudo tee -a $INSTALLED_LIST