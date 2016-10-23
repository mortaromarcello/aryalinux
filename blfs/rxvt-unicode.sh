#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak rxvt-unicode is a clone of thebr3ak terminal emulator rxvt, an Xbr3ak Window System terminal emulator which includes support for XFT andbr3ak Unicode.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:xorg-server
#OPT:gdk-pixbuf
#OPT:startup-notification


#VER:rxvt-unicode:9.22


NAME="rxvt-unicode"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 || wget -nc http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.22.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rxvt-unicode/rxvt-unicode-9.22.tar.bz2


URL=http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.22.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
! Use the specified colour as the windows background colour [default white]
URxvt*background: black
! Use the specified colour as the windows foreground colour [default black]
URxvt*foreground: yellow
! Select the fonts to be used. This is a comma separated list of font names
URxvt*font: xft:Monospace:pixelsize=18
! Comma-separated list(s) of perl extension scripts (default: "default")
URxvt*perl-ext: matcher
! Specifies the program to be started with a URL argument. Used by
URxvt*url-launcher: firefox
! When clicked with the mouse button specified in the "matcher.button" resource
! (default 2, or middle), the program specified in the "matcher.launcher"
! resource (default, the "url-launcher" resource, "sensible-browser") will be
! started with the matched text as first argument.
! Below, default modified to mouse left button.
URxvt*matcher.button: 1
EOF


xrdb -query


xrdb -merge ~/.Xresources


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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
