#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:psutils
#DEP:cups


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz


TARBALL=a2ps-4.14.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

autoconf &&
sed -i -e "s/GPERF --version |/& head -n 1 |/" \
       -e "s|/usr/local/share|/usr/share|" configure &&

./configure --prefix=/usr  \
    --sysconfdir=/etc/a2ps \
    --enable-shared        \
    --with-medium=letter   &&
make                       &&
touch doc/*.info

cat > 1434987998842.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
tar -xf ../i18n-fonts-0.1.tar.bz2 &&
cp -v i18n-fonts-0.1/fonts/* /usr/share/a2ps/fonts               &&
cp -v i18n-fonts-0.1/afm/* /usr/share/a2ps/afm                   &&
pushd /usr/share/a2ps/afm    &&
  ./make_fonts_map.sh        &&
  mv fonts.map.new fonts.map &&
popd
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "a2ps=>`date`" | sudo tee -a $INSTALLED_LIST