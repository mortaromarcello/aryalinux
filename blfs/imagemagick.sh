#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak ImageMagick is a collection ofbr3ak tools and libraries to read, write, and manipulate an image inbr3ak various image formats. Image processing operations are availablebr3ak from the command line. Bindings for Perl and C++ are alsobr3ak available.br3ak
#SECTION:general

#REC:x7lib
#OPT:cups
#OPT:curl
#OPT:ffmpeg
#OPT:p7zip
#OPT:sane
#OPT:wget
#OPT:xdg-utils
#OPT:xterm
#OPT:gnupg
#OPT:jasper
#OPT:lcms
#OPT:lcms2
#OPT:libexif
#OPT:libjpeg
#OPT:libpng
#OPT:librsvg
#OPT:libtiff
#OPT:libwebp
#OPT:openjpeg2
#OPT:pango
#OPT:gs
#OPT:gimp
#OPT:graphviz
#OPT:inkscape
#OPT:enscript
#OPT:texlive
#OPT:tl-installer


#VER:urt-b:3.1
#VER:ImageMagick-6.9.6:0
#VER:ralcgm:3.51


NAME="imagemagick"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.6-0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.6-0.tar.xz || wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.6-0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ImageMagick/ImageMagick-6.9.6-0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.6-0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.6-0.tar.xz || wget -nc https://www.imagemagick.org/download/releases/ImageMagick-6.9.6-0.tar.xz
wget -nc http://www.mcmurchy.com/ralcgm/ralcgm-3.51.tar.gz
wget -nc http://www.mcmurchy.com/urt/urt-3.1b.tar.gz


URL=https://www.imagemagick.org/download/releases/ImageMagick-6.9.6-0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i '/seems to be moved/ s/^/true #/' config/ltmain.sh &&

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --with-perl       \
            --disable-static  &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-6.9.6 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
