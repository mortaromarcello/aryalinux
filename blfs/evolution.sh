#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:evolution:3.20.4

#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gtkhtml
#REQ:itstool
#REQ:libgdata
#REQ:shared-mime-info
#REQ:webkitgtk2
#REC:bogofilter
#REC:enchant
#REC:gnome-desktop
#REC:highlight
#REC:libcanberra
#REC:libgweather
#REC:libnotify
#REC:seahorse
#OPT:clutter-gtk
#OPT:geoclue
#OPT:geocode-glib
#OPT:libchamplain
#OPT:gtk-doc
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/evolution/3.20/evolution-3.20.4.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution/3.20/evolution-3.20.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution/evolution-3.20.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution/evolution-3.20.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution/3.20/evolution-3.20.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evolution/evolution-3.20.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evolution/evolution-3.20.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evolution/evolution-3.20.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtkspell    \
            --disable-pst-import  \
            --disable-autoar      \
            --disable-libcryptui  \
            --disable-spamassassin &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "evolution=>`date`" | sudo tee -a $INSTALLED_LIST

