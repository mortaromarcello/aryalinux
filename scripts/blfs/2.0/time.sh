#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/time/time-1.7.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/time/time-1.7.tar.gz


TARBALL=time-1.7.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/$(ACLOCAL)//' Makefile.in                                            &&
sed -i 's/lu", ptok ((UL) resp->ru.ru_maxrss)/ld", resp->ru.ru_maxrss/' time.c &&
./configure --prefix=/usr --infodir=/usr/share/info                            &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "time=>`date`" | sudo tee -a $INSTALLED_LIST