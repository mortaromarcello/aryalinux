#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:ffmpeg
#DEP:alsa-lib
#DEP:lame
#DEP:libdvdread
#DEP:libmpeg2
#DEP:x7lib


cd $SOURCE_DIR

wget -nc https://bitbucket.org/france/transcode-tcforge/downloads/transcode-1.1.7.tar.bz2
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/transcode-1.1.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/transcode-1.1.7-ffmpeg2-1.patch


TARBALL=transcode-1.1.7.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:#include <freetype/ftglyph.h>:#include FT_GLYPH_H:" filter/subtitler/load_font.c

sed -i 's|doc/transcode|&-$(PACKAGE_VERSION)|' \
       $(find . -name Makefile.in -exec grep -l 'docsdir =' {} \;) &&

sed -i "s:av_close_input_file:avformat_close_input:g" \
       import/probe_ffmpeg.c                                       &&

patch -Np1 -i ../transcode-1.1.7-ffmpeg2-1.patch                   &&
./configure --prefix=/usr \
            --enable-alsa \
            --enable-libmpeg2 &&
make

cat > 1434987998839.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "transcode=>`date`" | sudo tee -a $INSTALLED_LIST