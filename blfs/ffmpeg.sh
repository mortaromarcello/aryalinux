#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:ffmpeg:2.3.6

URL=http://ffmpeg.org/releases/ffmpeg-2.3.6.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --enable-x11grab     \
            --docdir=/usr/share/doc/ffmpeg-2.3.6  &&
make "-j`nproc`" &&
gcc tools/qt-faststart.c -o tools/qt-faststart
sudo make install
sudo install -v -m755    tools/qt-faststart /usr/bin
sudo install -v -m644    doc/*.txt \
                    /usr/share/doc/ffmpeg-2.3.6

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "ffmpeg=>`date`" | sudo tee -a $INSTALLED_LIST
