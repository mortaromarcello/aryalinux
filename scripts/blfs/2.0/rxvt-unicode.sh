#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:installing


cd $SOURCE_DIR

wget -nc http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.21.tar.bz2


TARBALL=rxvt-unicode-9.21.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --enable-everything &&
make

cat > 1434987998830.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat >> /etc/X11/app-defaults/URxvt << "EOF"
URxvt*perl-ext: matcher
URxvt*urlLauncher: firefox
URxvt.background: black
URxvt.foreground: yellow
URxvt*font: xft:Monospace:pixelsize=12
EOF

# Start the urxvtd daemon
urxvtd -q -f -o &

cat > /usr/share/applications/urxvt.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Rxvt-Unicode Terminal
Comment=Use the command line
GenericName=Terminal
Exec=urxvt 
Terminal=false
Type=Application
Icon=utilities-terminal
Categories=GTK;Utility;TerminalEmulator;
#StartupNotify=true
Keywords=console;command line;execute;
EOF

update-desktop-database -q


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "rxvt-unicode=>`date`" | sudo tee -a $INSTALLED_LIST