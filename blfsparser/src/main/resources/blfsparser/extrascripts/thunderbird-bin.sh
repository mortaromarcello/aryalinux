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
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:cyrus-sasl
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
	URL=https://ftp.mozilla.org/pub/thunderbird/releases/latest/linux-i686/en-US/thunderbird-38.3.0.tar.bz2
else
	URL=https://ftp.mozilla.org/pub/thunderbird/releases/latest/linux-x86_64/en-US/thunderbird-38.3.0.tar.bz2
fi

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998846.sh << "ENDOFFILE"
mkdir /opt/thunderbird
cp -rf * /opt/thunderbird

cat > /usr/share/applications/thunderbird.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Exec=/opt/thunderbird/thunderbird %u
Terminal=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
StartupNotify=true
EOF

for s in 16 22 24 32 48 256
do
install -v -Dm644 /opt/thunderbird/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/thunderbird.png
done &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&

unset s

ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "thunderbird-bin=>`date`" | sudo tee -a $INSTALLED_LIST
