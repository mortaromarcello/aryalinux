#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#REQ:alsa-lib
#REQ:gtk2
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:gst-plugins-base
#OPT:gst-plugins-good
#OPT:gst-ffmpeg
#OPT:gst10-plugins-base
#OPT:gst10-plugins-good
#OPT:gst10-libav
#OPT:libnotify
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:wget
#OPT:wireless_tools


cd $SOURCE_DIR

if [ $(uname -m) != "x86_64" ]
then
	URL=http://download-origin.cdn.mozilla.net/pub/firefox/releases/41.0.2/linux-i686/en-US/firefox-41.0.2.tar.bz2
else
	URL=http://download-origin.cdn.mozilla.net/pub/firefox/releases/41.0.2/linux-x86_64/en-US/firefox-41.0.2.tar.bz2
fi

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998846.sh << "ENDOFFILE"
mkdir /opt/firefox
cp -rf * /opt/firefox

cat > /usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=/opt/firefox/firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

for s in 16 32 48
do
install -v -Dm644 /opt/firefox/browser/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/firefox.png
done &&
install -v -Dm644 /opt/firefox/browser/icons/mozicon128.png \
                  /usr/share/icons/hicolor/128x128/apps/firefox.png
ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "firefox-bin=>`date`" | sudo tee -a $INSTALLED_LIST