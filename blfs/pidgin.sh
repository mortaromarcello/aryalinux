#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Pidgin is a Gtk+ 2 instantbr3ak messaging client that can connect with a wide range of networksbr3ak including AIM, ICQ, GroupWise, MSN, Jabber, IRC, Napster,br3ak Gadu-Gadu, SILC, Zephyr and Yahoo!br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:gtk2
#REC:libgcrypt
#REC:gstreamer10
#REC:gnutls
#REC:nss
#OPT:avahi
#OPT:check
#OPT:cyrus-sasl
#OPT:dbus
#OPT:GConf
#OPT:libidn
#OPT:networkmanager
#OPT:sqlite
#OPT:startup-notification
#OPT:tcl
#OPT:tk
#OPT:mitkrb
#OPT:xdg-utils


#VER:pidgin:2.11.0


NAME="pidgin"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/pidgin/pidgin-2.11.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pidgin/pidgin-2.11.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pidgin/pidgin-2.11.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pidgin/pidgin-2.11.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pidgin/pidgin-2.11.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pidgin/pidgin-2.11.0.tar.bz2


URL=http://downloads.sourceforge.net/pidgin/pidgin-2.11.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --with-gstreamer=1.0 \
            --disable-avahi      \
            --disable-gtkspell   \
            --disable-meanwhile  \
            --disable-idn        \
            --disable-nm         \
            --disable-vv         \
            --disable-tcl        &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/doc/pidgin-2.11.0 &&
cp -v README doc/gtkrc-2.0 /usr/share/doc/pidgin-2.11.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST