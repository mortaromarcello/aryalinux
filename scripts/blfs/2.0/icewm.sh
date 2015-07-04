#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gdk-pixbuf
#DEP:installing


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/icewm/icewm-1.3.8.tar.gz


TARBALL=icewm-1.3.8.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/^LIBS/s/\(.*\)/\1 -lfontconfig/' src/Makefile.in &&
./configure --prefix=/usr &&
make

cat > 1434987998796.sh << "ENDOFFILE"
make install         &&
make install-docs    &&
make install-man     &&
make install-desktop
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh

echo icewm-session > ~/.xinitrc

mkdir -v ~/.icewm                                       &&
cp -v /usr/share/icewm/keys ~/.icewm/keys               &&
cp -v /usr/share/icewm/menu ~/.icewm/menu               &&
cp -v /usr/share/icewm/preferences ~/.icewm/preferences &&
cp -v /usr/share/icewm/toolbar ~/.icewm/toolbar         &&
cp -v /usr/share/icewm/winoptions ~/.icewm/winoptions

cat > ~/.icewm/menu << "EOF" &&
prog Urxvt xterm urxvt
prog GVolWheel /usr/share/pixmaps/gvolwheel/audio-volume-medium gvolwheel
separator
menufile General folder general
menufile Multimedia folder multimedia
menufile Tool_bar folder toolbar
EOF
cat > ~/.icewm/general << "EOF" &&
prog Firefox firefox firefox
prog Epiphany /usr/share/icons/gnome/16x16/apps/web-browser epiphany
prog Midori /usr/share/icons/hicolor/24x24/apps/midori midori
separator
prog Gimp /usr/share/icons/hicolor/16x16/apps/gimp gimp
separator
prog Evince /usr/share/icons/hicolor/16x16/apps/evince evince
prog Epdfview /usr/share/epdfview/pixmaps/icon_epdfview-48 epdfview
EOF
cat > ~/.icewm/multimedia << "EOF"
prog Audacious /usr/share/icons/hicolor/48x48/apps/audacious audacious
separator
prog Parole /usr/share/icons/hicolor/16x16/apps/parole parole
prog Totem /usr/share/icons/hicolor/16x16/apps/totem totem
prog Vlc /usr/share/icons/hicolor/16x16/apps/vlc vlc
prog Xine /usr/share/pixmaps/xine xine
EOF

cat > ~/.icewm/startup << "EOF"
rox -p Default &
EOF &&
chmod +x ~/.icewm/startup


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "icewm=>`date`" | sudo tee -a $INSTALLED_LIST