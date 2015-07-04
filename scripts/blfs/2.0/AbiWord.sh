#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:boost
#DEP:fribidi
#DEP:goffice010
#DEP:wv
#DEP:enchant


cd $SOURCE_DIR

wget -nc http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-3.0.1.tar.gz


TARBALL=abiword-3.0.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998827.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998827.sh
sudo ./1434987998827.sh
sudo rm -rf 1434987998827.sh

tar -xf ../abiword-docs-3.0.1.tar.gz &&
cd abiword-docs-3.0.1                &&
./configure --prefix=/usr            &&
make

cat > 1434987998827.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998827.sh
sudo ./1434987998827.sh
sudo rm -rf 1434987998827.sh

ls /usr/share/abiword-3.0/templates

install -v -m750 -d ~/.AbiSuite/templates &&
install -v -m640    /usr/share/abiword-3.0/templates/normal.awt-<em class="replaceable"><code><lang></em> \
                    ~/.AbiSuite/templates/normal.awt


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "AbiWord=>`date`" | sudo tee -a $INSTALLED_LIST