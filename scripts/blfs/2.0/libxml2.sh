#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2
#DEP:python3


cd $SOURCE_DIR

wget -nc http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz
wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz


TARBALL=libxml2-2.9.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed \
  -e /xmlInitializeCatalog/d \
  -e 's/((ent->checked =.*&&/(((ent->checked == 0) ||\
          ((ent->children == NULL) \&\& (ctxt->options \& XML_PARSE_NOENT))) \&\&/' \
  -i parser.c

./configure --prefix=/usr --disable-static --with-history &&
make

tar xf ../xmlts20130923.tar.gz

cat > 1434987998763.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libxml2=>`date`" | sudo tee -a $INSTALLED_LIST