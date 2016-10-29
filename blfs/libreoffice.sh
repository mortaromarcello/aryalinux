#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak LibreOffice is a full-featuredbr3ak office suite. It is largely compatible with Microsoft Office and is descended frombr3ak OpenOffice.org.br3ak"
SECTION="xsoft"
VERSION=5.2.2.2
NAME="libreoffice"

#REQ:perl-modules#perl-archive-zip
#REQ:unzip
#REQ:wget
#REQ:general_which
#REQ:zip
#REC:apr
#REC:boost
#REC:clucene
#REC:cups
#REC:curl
#REC:dbus-glib
#REC:libjpeg
#REC:glu
#REC:graphite2
#REC:gst10-plugins-base
#REC:gtk3
#REC:gtk2
#REC:harfbuzz
#REC:icu
#REC:libatomic_ops
#REC:lcms2
#REC:librsvg
#REC:libxml2
#REC:libxslt
#REC:mesa
#REC:neon
#REC:nss
#REC:openldap
#REC:openssl
#REC:gnutls
#REC:poppler
#REC:postgresql
#REC:python3
#REC:redland
#REC:serf
#REC:unixodbc
#OPT:apache-ant
#OPT:avahi
#OPT:bluez
#OPT:dconf
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:gdb
#OPT:mariadb
#OPT:mitkrb
#OPT:nasm
#OPT:openjdk
#OPT:sane
#OPT:valgrind
#OPT:vlc
#OPT:telepathy-glib
#OPT:zenity


cd $SOURCE_DIR

URL=http://download.documentfoundation.org/libreoffice/src/5.2.2/libreoffice-5.2.2.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-5.2.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-5.2.2.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-5.2.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-5.2.2.2.tar.xz || wget -nc http://download.documentfoundation.org/libreoffice/src/5.2.2/libreoffice-5.2.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-5.2.2.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/5.2.2/libreoffice-dictionaries-5.2.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-5.2.2.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-5.2.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-5.2.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-dictionaries-5.2.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-5.2.2.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/5.2.2/libreoffice-help-5.2.2.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-help-5.2.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-help-5.2.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-help-5.2.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-help-5.2.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-help-5.2.2.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/5.2.2/libreoffice-translations-5.2.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-translations-5.2.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-translations-5.2.2.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-translations-5.2.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-translations-5.2.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-translations-5.2.2.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

read -p "Enter language : " LANGUAGE


tar -xf libreoffice-5.2.2.2.tar.xz --no-overwrite-dir &&
cd libreoffice-5.2.2.2


install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-5.2.2.2.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-5.2.2.2.tar.xz         external/tarballs/


ln -sv ../../../libreoffice-translations-5.2.2.2.tar.xz external/tarballs/


export LO_PREFIX=/usr


sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&
sed -e "/distro-install-file-lists/d" -i Makefile.in &&
./autogen.sh --prefix=$LO_PREFIX         \
             --sysconfdir=/etc           \
             --with-vendor=AryaLinux          \
             --with-lang="$LANGUAGE"      \
             --with-help                 \
             --with-myspell-dicts        \
             --with-alloc=system         \
             --without-java              \
             --without-system-dicts      \
             --disable-dconf             \
             --disable-odk               \
             --disable-firebird-sdbc     \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-system-apr           \
             --with-system-boost=yes     \
             --with-system-cairo         \
             --with-system-clucene       \
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
             --with-system-neon          \
             --with-system-nss           \
             --with-system-odbc          \
             --with-system-openldap      \
             --with-system-openssl       \
             --with-system-poppler       \
             --with-system-postgresql    \
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib


make build-nocheck



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make distro-pack-install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ "$LO_PREFIX" != "/usr" ]; then
  # This symlink is necessary for the desktop menu entries
  ln -svf $LO_PREFIX/lib/libreoffice/program/soffice /usr/bin/libreoffice &&
  # Icons
  mkdir -vp /usr/share/pixmaps
  for i in $LO_PREFIX/share/icons/hicolor/32x32/apps/*; do
    ln -svf $i /usr/share/pixmaps
  done &&
  # Desktop menu entries
  for i in $LO_PREFIX/lib/libreoffice/share/xdg/*; do
    ln -svf $i /usr/share/applications/libreoffice-$(basename $i)
  done &&
  # Man pages
  for i in $LO_PREFIX/share/man/man1/*; do
    ln -svf $i /usr/share/man/man1/
  done
  unset i
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
