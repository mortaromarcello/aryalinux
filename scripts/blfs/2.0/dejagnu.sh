#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:expect


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.5.2.tar.gz
wget -nc ftp://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.5.2.tar.gz


TARBALL=dejagnu-1.5.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi &&
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi

cat > 1434987998774.sh << "ENDOFFILE"
make install &&
install -v -dm755   /usr/share/doc/dejagnu-1.5.2 &&
install -v -m644    doc/dejagnu.{html,txt} \
                    /usr/share/doc/dejagnu-1.5.2
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dejagnu=>`date`" | sudo tee -a $INSTALLED_LIST