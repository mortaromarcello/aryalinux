#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ekiga:4.0.1

#REQ:boost
#REQ:gnome-icon-theme
#REQ:gtk2
#REQ:opal
#REC:dbus-glib
#REC:GConf
#REC:libnotify
#OPT:avahi
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-eds     \
            --disable-gdu     \
            --disable-ldap    \
            --disable-scrollkeeper &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ekiga=>`date`" | sudo tee -a $INSTALLED_LIST

