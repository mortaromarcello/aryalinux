#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib
#DEP:gtk2
#DEP:unzip
#DEP:zip
#DEP:icu
#DEP:libevent
#DEP:libvpx
#DEP:nspr
#DEP:nss
#DEP:sqlite
#DEP:yasm


cd $SOURCE_DIR

wget -nc https://ftp.mozilla.org/pub/mozilla.org/seamonkey/releases/2.32.1/source/seamonkey-2.32.1.source.tar.bz2
wget -nc ftp://ftp.mozilla.org/pub/seamonkey/releases/2.32.1/source/seamonkey-2.32.1.source.tar.bz2


TARBALL=seamonkey-2.32.1.source.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > mozconfig << "EOF"
# The following switch reduces optimization level when building
# SeaMonkey due to bugs in GCC-4.8 and early GCC-4.9 series that
# would cause build to fail on 32 bit systems. If you are not using
# GCC-4.9.2 or later, or any supported version released before
# GCC-4.8.0 on a 32 bit system, uncomment the following line:
#ac_add_options --enable-optimize=-O2


# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi

# If you have installed libnotify comment out this line:
ac_add_options --disable-libnotify

# Comment out following option if you have PulseAudio installed
ac_add_options --disable-pulseaudio

# GStreamer is necessary for H.264 video playback in HTML5 Video Player.
# To enable it, make sure you also set "media.gstreamer.enabled" to
# "true" in about:config.

# If you don't have GStreamer 0.10.x installed, uncomment this line:
#ac_add_options --disable-gstreamer
# or uncomment this line if you have GStreamer 1.x.y installed:
#ac_add_options --enable-gstreamer=1.0

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification

# If you have not installed Yasm then uncomment this line:
#ac_add_options --disable-webm

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

ac_add_options --enable-strip
ac_add_options --enable-install-strip

ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier

ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-pthreads

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/moz-build-dir
EOF

mkdir -v mozilla/moz-build-dir

make -f client.mk

cat > 1434987998828.sh << "ENDOFFILE"
make -f client.mk install INSTALL_SDK=       &&
chown -R root:root /usr/lib/seamonkey-2.32.1 &&
install -v -m644 moz-build-dir/dist/man/man1/seamonkey.1 /usr/share/man/man1
ENDOFFILE
chmod a+x 1434987998828.sh
sudo ./1434987998828.sh
sudo rm -rf 1434987998828.sh

cat > 1434987998828.sh << "ENDOFFILE"
make -f client.mk install
ENDOFFILE
chmod a+x 1434987998828.sh
sudo ./1434987998828.sh
sudo rm -rf 1434987998828.sh

cat > 1434987998828.sh << "ENDOFFILE"
mkdir -pv /usr/share/{applications,pixmaps} &&

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

ln -sfv /usr/lib/seamonkey-2.32.1/chrome/icons/default/seamonkey.png \
        /usr/share/pixmaps
ENDOFFILE
chmod a+x 1434987998828.sh
sudo ./1434987998828.sh
sudo rm -rf 1434987998828.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "seamonkey=>`date`" | sudo tee -a $INSTALLED_LIST