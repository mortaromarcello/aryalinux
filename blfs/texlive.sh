#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:texlive-source:20150521
#VER:texlive-texmf:20150523

#REC:gs
#REC:fontconfig
#REC:freetype2
#REC:gc
#REC:graphite2
#REC:harfbuzz
#REC:icu
#REC:libpaper
#REC:libpng
#REC:poppler
#REC:python2
#REC:ruby
#REC:xorg-server


cd $SOURCE_DIR

URL=ftp://tug.org/texlive/historic/2015/texlive-20150521-source.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20150521-source.tar.xz || wget -nc ftp://tug.org/texlive/historic/2015/texlive-20150521-source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20150521-source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20150521-source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20150521-source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20150521-source.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20150523-texmf.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20150523-texmf.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20150523-texmf.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20150523-texmf.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20150523-texmf.tar.xz || wget -nc ftp://tug.org/texlive/historic/2015/texlive-20150523-texmf.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2015 addition
/opt/texlive/2015/lib
# End texlive 2015 addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
mkdir texlive-build &&
cd texlive-build    &&
../configure                                        \
    --prefix=/opt/texlive/2015                      \
    --bindir=/opt/texlive/2015/bin/$TEXARCH         \
    --datarootdir=/opt/texlive/2015                 \
    --includedir=/opt/texlive/2015/include          \
    --infodir=/opt/texlive/2015/texmf-dist/doc/info \
    --libdir=/opt/texlive/2015/lib                  \
    --mandir=/opt/texlive/2015/texmf-dist/doc/man   \
    --disable-native-texlive-build                  \
    --disable-static --enable-shared                \
    --with-system-cairo                             \
    --with-system-fontconfig                        \
    --with-system-freetype2                         \
    --with-system-gmp                               \
    --with-system-graphite2                         \
    --with-system-harfbuzz                          \
    --with-system-icu                               \
    --with-system-libgs                             \
    --with-system-libpaper                          \
    --with-system-libpng                            \
    --with-system-mpfr                              \
    --with-system-pixman                            \
    --with-system-poppler                           \
    --with-system-xpdf                              \
    --with-system-zlib                              \
    --with-banner-add=" - BLFS" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.04/blfs-systemd-units-20150310.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20150310
make install-strip &&
make texlinks &&
ldconfig &&
mkdir -pv /opt/texlive/2015/tlpkg/TeXLive/ &&
install -v -m444 ../texk/tests/TeXLive/* /opt/texlive/2015/tlpkg/TeXLive/

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20150310
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../../texlive-20150523-texmf.tar.xz -C /opt/texlive/2015 --strip-components=1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mktexlsr &&
fmtutil-sys --all &&
mtxrun --generate

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "texlive=>`date`" | sudo tee -a $INSTALLED_LIST

