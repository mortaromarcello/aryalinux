#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:seamonkey-.source:2.39

#REQ:alsa-lib
#REQ:gtk2
#REQ:zip
#REQ:unzip
#REQ:yasm
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:gst10-plugins-base
#OPT:gst10-plugins-good
#OPT:gst10-libav
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:valgrind
#OPT:wget
#OPT:wireless_tools


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/mozilla.org/seamonkey/releases/2.39/source/seamonkey-2.39.source.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/seamonkey/seamonkey-2.39.source.tar.xz || wget -nc https://ftp.mozilla.org/pub/mozilla.org/seamonkey/releases/2.39/source/seamonkey-2.39.source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/seamonkey/seamonkey-2.39.source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/seamonkey/seamonkey-2.39.source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/seamonkey/seamonkey-2.39.source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/seamonkey/seamonkey-2.39.source.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.
# If desired, you can reduce the number of cores used, e.g. to 1, by
# uncommenting the next line and setting a valid number of CPU cores.
#mk_add_options MOZ_MAKE_FLAGS="-j1"
# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus
# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi
# GStreamer is necessary for H.264 video playback in HTML5 Video Player;
# to be enabled, also remember to set "media.gstreamer.enabled" to "true"
# in about:config. If you have GStreamer 1.x.y, uncomment this line:
#ac_add_options --enable-gstreamer=1.0
# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification
# Comment out following option if you have PulseAudio installed
ac_add_options --disable-pulseaudio
# Comment out following option if you have gconf installed
ac_add_options --disable-gconf
# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu
# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=suite
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier
# Use internal cairo due to reports of unstable execution with
# system cairo
#ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/moz-build-dir
EOF


sed -e '/^ftglyph.h/i ftfntfmt.h'                     \
    -e '/^freetype\/ftcache.h/a freetype\/ftfntfmt.h' \
    -i mozilla/config/system-headers


mkdir -vp mozilla/moz-build-dir


make -f client.mk



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make  -f client.mk install INSTALL_SDK= &&
chown -R 0:0 /usr/lib/seamonkey-2.39    &&
cp    -v moz-build-dir/dist/man/man1/seamonkey.1 /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C moz-build-dir install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/{applications,pixmaps}              &&
cat > /usr/share/applications/seamonkey.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=SeaMonkey
Comment=The Mozilla Suite
Icon=seamonkey
Exec=seamonkey
Categories=Network;GTK;Application;Email;Browser;WebBrowser;News;
StartupNotify=true
Terminal=false
EOF
ln -sfv /usr/lib/seamonkey-2.39/chrome/icons/default/seamonkey.png \
        /usr/share/pixmaps

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "seamonkey=>`date`" | sudo tee -a $INSTALLED_LIST

