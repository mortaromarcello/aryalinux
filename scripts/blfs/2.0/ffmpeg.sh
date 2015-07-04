#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:fdk-aac
#DEP:lame
#DEP:libass
#DEP:libtheora
#DEP:libvorbis
#DEP:libvpx
#DEP:yasm
#DEP:x264


cd $SOURCE_DIR

wget -nc http://ffmpeg.org/releases/ffmpeg-2.5.4.tar.bz2


TARBALL=ffmpeg-2.5.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/-lflite"/-lflite -lasound"/' configure &&
./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libmp3lame  \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-x11grab     \
            --docdir=/usr/share/doc/ffmpeg-2.5.4 &&
make &&
gcc tools/qt-faststart.c -o tools/qt-faststart

cat > 1434987998839.sh << "ENDOFFILE"
make install &&
install -v -m755 tools/qt-faststart /usr/bin &&
install -v -m644 doc/*.txt /usr/share/doc/ffmpeg-2.5.4
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ffmpeg=>`date`" | sudo tee -a $INSTALLED_LIST