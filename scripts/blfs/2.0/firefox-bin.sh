#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://download-installer.cdn.mozilla.net/pub/firefox/releases/38.0.5/linux-i686/en-US/firefox-38.0.5.tar.bz2


TARBALL=firefox-38.0.5.tar.bz2
DIRECTORY=firefox

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