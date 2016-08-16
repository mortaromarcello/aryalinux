#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:texlive-b-texmf:20160523
#VER:texlive-b-source:20160523

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

URL=ftp://tug.org/texlive/historic/2016/texlive-20160523b-source.tar.xz

wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20160523b-texmf-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20160523b-texmf-upstream_fixes-1.patch
wget -nc ftp://tug.org/texlive/historic/2016/texlive-20160523b-texmf.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20160523b-source-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20160523b-source-upstream_fixes-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc ftp://tug.org/texlive/historic/2016/texlive-20160523b-source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2016 addition
/opt/texlive/2016/lib
# End texlive 2016 addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
patch -Np1 -i ../texlive-20160523b-source-upstream_fixes-1.patch &&
mkdir texlive-build &&
cd texlive-build    &&
../configure                                        \
    --prefix=/opt/texlive/2016                      \
    --bindir=/opt/texlive/2016/bin/$TEXARCH         \
    --datarootdir=/opt/texlive/2016                 \
    --includedir=/opt/texlive/2016/include          \
    --infodir=/opt/texlive/2016/texmf-dist/doc/info \
    --libdir=/opt/texlive/2016/lib                  \
    --mandir=/opt/texlive/2016/texmf-dist/doc/man   \
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
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-strip &&
make texlinks &&
ldconfig &&
mkdir -pv /opt/texlive/2016/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2016/tlpkg/TeXLive/

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../../texlive-20160523b-texmf.tar.xz -C /opt/texlive/2016 --strip-components=1 &&
pushd /opt/texlive/2016 &&
patch -Np1 -i /sources/texlive-20160523b-texmf-upstream_fixes-1.patch &&
popd

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

