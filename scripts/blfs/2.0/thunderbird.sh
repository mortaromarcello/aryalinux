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
#DEP:libevent
#DEP:libvpx
#DEP:nspr
#DEP:nss
#DEP:sqlite
#DEP:yasm


cd $SOURCE_DIR

wget -nc https://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/31.4.0/source/thunderbird-31.4.0.source.tar.bz2
wget -nc ftp://ftp.mozilla.org/pub/thunderbird/releases/31.4.0/source/thunderbird-31.4.0.source.tar.bz2


TARBALL=thunderbird-31.4.0.source.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > mozconfig << "EOF"
# The following switch reduces optimization level when building
# Thunderbird due to bugs in GCC-4.8 and early GCC-4.9 series that
# would cause build to fail on 32 bit systems. If you are not using
# GCC-4.9.2 or later, or any supported version released before
# GCC-4.8.0 on a 32 bit system, uncomment the following line:
#ac_add_options --enable-optimize=-O2

# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus

# If you have installed wireless-tools comment out this line:
ac_add_options --disable-necko-wifi

# If you have installed libnotify comment out this line:
ac_add_options --disable-libnotify

# Comment out following option if you have PulseAudio installed
ac_add_options --disable-pulseaudio

# GStreamer is necessary for H.264 video playback in HTML5 Video Player.
# To enable it, make sure you also set "media.gstreamer.enabled" to
# "true" in about:config.

# If you have GStreamer 0.10.x installed, comment out this line:
ac_add_options --disable-gstreamer
# or uncomment this line if you have GStreamer 1.x.y installed:
#ac_add_options --enable-gstreamer=1.0

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification

# If you have not installed Yasm then uncomment this line:
#ac_add_options --disable-webm

# If you want to compile the Mozilla Calendar, uncomment this line:
#ac_add_options --enable-calendar

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

ac_add_options --disable-crashreporter
ac_add_options --disable-installer
ac_add_options --disable-updater
ac_add_options --disable-debug
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
EOF

make -f client.mk

cat > 1434987998830.sh << "ENDOFFILE"
make -f client.mk install INSTALL_SDK=
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > 1434987998830.sh << "ENDOFFILE"
make -f client.mk install
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > 1434987998830.sh << "ENDOFFILE"
mkdir -pv /usr/share/applications &&

cat > /usr/share/applications/thunderbird.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Exec=thunderbird %u
Terminal=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
StartupNotify=true
EOF

for s in 16 22 24 32 48 256
do
install -v -Dm644 /usr/lib/thunderbird-31.4.0/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/thunderbird.png
done &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
unset s
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "thunderbird=>`date`" | sudo tee -a $INSTALLED_LIST