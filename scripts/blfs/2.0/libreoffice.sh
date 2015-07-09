#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:perl-modules#perl-archive-zip
#DEP:unzip
#DEP:wget
#DEP:which
#DEP:zip
#DEP:boost
#DEP:clucene
#DEP:cups
#DEP:curl
#DEP:dbus-glib
#DEP:glu
#DEP:graphite2
#DEP:gst-plugins-base
#DEP:gst10-plugins-base
#DEP:gtk2
#DEP:harfbuzz
#DEP:icu
#DEP:lcms2
#DEP:libatomic_ops
#DEP:libjpeg
#DEP:librsvg
#DEP:libxml2
#DEP:libxslt
#DEP:mesalib
#DEP:neon
#DEP:npapi-sdk
#DEP:nss
#DEP:openldap
#DEP:openssl
#DEP:poppler
#DEP:python3
#DEP:redland
#DEP:unixodbc


cd $SOURCE_DIR

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libreoffice-4.4.0.3-gcc_4_9_0-2.patch
wget -nc http://download.documentfoundation.org/libreoffice/src/4.4.0/libreoffice-4.4.0.3.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/4.4.0/libreoffice-dictionaries-4.4.0.3.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/4.4.0/libreoffice-help-4.4.0.3.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/4.4.0/libreoffice-translations-4.4.0.3.tar.xz


TARBALL=libreoffice-4.4.0.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

install -dm755 external/tarballs &&

ln -sfv ../../../libreoffice-dictionaries-4.4.0.3.tar.xz external/tarballs/ &&
ln -sfv ../../../libreoffice-help-4.4.0.3.tar.xz external/tarballs/

ln -sfv ../../../libreoffice-translations-4.4.0.3.tar.xz external/tarballs/

patch -Np1 -i ../libreoffice-4.4.0.3-gcc_4_9_0-2.patch &&

sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&

sed -e "/distro-install-file-lists/d" \
    -i Makefile.in                            &&

sed -e "/ustrbuf/a #include <algorithm>" \
    -i svl/source/misc/gridprinter.cxx        &&

chmod -v +x bin/unpack-sources                &&

./autogen.sh --prefix=/usr               \
             --sysconfdir=/etc           \
             --with-vendor="BLFS"        \
             --with-lang="en-US pt-BR"   \
             --with-help                 \
             --with-myspell-dicts        \
             --with-alloc=system         \
             --without-java              \
             --without-system-dicts      \
             --disable-gconf             \
             --disable-odk               \
             --disable-postgresql-sdbc   \
             --enable-release-build      \
             --enable-python=system      \
             --with-system-boost         \
             --with-system-clucene       \
             --with-system-cairo         \
             --with-system-curl          \
             --with-system-expat         \
             --with-system-graphite      \
             --with-system-harfbuzz      \
             --with-system-icu           \
             --with-system-jpeg          \
             --with-system-lcms2         \
             --with-system-libatomic_ops \
             --with-system-libpng        \
             --with-system-libxml        \
             --with-system-mesa-headers  \
             --with-system-neon          \
             --with-system-npapi-headers \
             --with-system-nss           \
             --with-system-odbc          \
             --with-system-openldap      \
             --with-system-openssl       \
             --with-system-poppler       \
             --with-system-redland       \
             --with-system-zlib          \
             --with-parallelism=$(getconf _NPROCESSORS_ONLN)

make "-j`nproc`" build

cat > 1434987998828.sh << "ENDOFFILE"
make distro-pack-install             &&
install -v -dm755 /usr/share/appdata &&
install -v -m644  sysui/desktop/appstream-appdata/*.xml \
                  /usr/share/appdata
ENDOFFILE
chmod a+x 1434987998828.sh
sudo ./1434987998828.sh
sudo rm -rf 1434987998828.sh

cat > 1434987998828.sh << "ENDOFFILE"
make DESTDIR=/var/cache/alps/binaries/libreoffice distro-pack-install             &&
install -v -dm755 /var/cache/alps/binaries/libreoffice/usr/share/appdata &&
install -v -m644  sysui/desktop/appstream-appdata/*.xml \
                  /var/cache/alps/binaries/libreoffice/usr/share/appdata
ENDOFFILE
chmod a+x 1434987998828.sh
sudo ./1434987998828.sh
sudo rm -rf 1434987998828.sh


 
cd $SOURCE_DIR
# sudo rm -rf $DIRECTORY
 
echo "libreoffice=>`date`" | sudo tee -a $INSTALLED_LIST
