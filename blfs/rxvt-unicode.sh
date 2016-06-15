#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:rxvt-unicode:9.21

#REQ:xorg-server
#OPT:gdk-pixbuf
#OPT:startup-notification


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/rxvt-unicode/rxvt-unicode-9.21.tar.bz2

wget -nc ftp://anduin.linuxfromscratch.org/BLFS/rxvt-unicode/rxvt-unicode-9.21.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.21.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.21.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.21.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.21.tar.bz2 || wget -nc http://anduin.linuxfromscratch.org/BLFS/rxvt-unicode/rxvt-unicode-9.21.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.21.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --enable-everything &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


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

