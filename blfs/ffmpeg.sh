#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:ffmpeg_.orig:3.0.2

URL=http://archive.ubuntu.com/ubuntu/pool/universe/f/ffmpeg/ffmpeg_3.0.2.orig.tar.xz

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
            --docdir=/usr/share/doc/ffmpeg-3.0.2  &&
make "-j`nproc`" &&
gcc tools/qt-faststart.c -o tools/qt-faststart
sudo make install
sudo install -v -m755    tools/qt-faststart /usr/bin
sudo install -v -m644    doc/*.txt \
                    /usr/share/doc/ffmpeg-3.0.2

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "ffmpeg=>`date`" | sudo tee -a $INSTALLED_LIST
