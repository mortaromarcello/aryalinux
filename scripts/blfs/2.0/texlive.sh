#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gs
#DEP:installing
#DEP:fontconfig
#DEP:freetype2
#DEP:gc
#DEP:graphite2
#DEP:harfbuzz
#DEP:icu
#DEP:libpaper
#DEP:libpng
#DEP:poppler
#DEP:python2
#DEP:ruby


cd $SOURCE_DIR

wget -nc ftp://tug.org/texlive/historic/2014/texlive-20140525-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2014/texlive-20140525-texmf.tar.xz


TARBALL=texlive-20140525-source.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
mkdir texlive-build &&
cd texlive-build    &&

../configure                                        \
    --prefix=/opt/texlive/2014                      \
    --bindir=/opt/texlive/2014/bin/$TEXARCH         \
    --datarootdir=/opt/texlive/2014                 \
    --includedir=/usr/include                       \
    --infodir=/opt/texlive/2014/texmf-dist/doc/info \
    --libdir=/usr/lib                               \
    --mandir=/opt/texlive/2014/texmf-dist/doc/man   \
    --disable-native-texlive-build                  \
    --disable-static --enable-shared                \
    --with-system-cairo                             \
    --with-system-fontconfig                        \
    --with-system-freetype2                         \
    --with-system-graphite2                         \
    --with-system-harfbuzz                          \
    --with-system-icu                               \
    --with-system-libgs                             \
    --with-system-libpaper                          \
    --with-system-libpng                            \
    --with-system-pixman                            \
    --with-system-poppler                           \
    --with-system-xpdf                              \
    --with-system-zlib                              \
    --with-banner-add=" - BLFS" &&
unset TEXARCH &&

make

cat > 1434987998843.sh << "ENDOFFILE"
make install &&
make texlinks
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh

cat > 1434987998843.sh << "ENDOFFILE"
mkdir -pv /opt/texlive/2014 &&
tar -xf ../../texlive-20140525-texmf.tar.xz -C /opt/texlive/2014 --strip-components=1
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "texlive=>`date`" | sudo tee -a $INSTALLED_LIST