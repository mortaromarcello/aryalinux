#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Ekiga is a VoIP, IP Telephony, andbr3ak Video Conferencing application that allows you to make audio andbr3ak video calls to remote users with SIP or H.323 compatible hardwarebr3ak and software. It supports many audio and video codecs and allbr3ak modern VoIP features for both SIP and H.323. Ekiga is the first Open Source application tobr3ak support both H.323 and SIP, as well as audio and video.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:boost
#REQ:gnome-icon-theme
#REQ:gtk2
#REQ:opal
#REC:dbus-glib
#REC:GConf
#REC:libnotify
#OPT:avahi
#OPT:openldap


#VER:ekiga:4.0.1


NAME="ekiga"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-eds     \
            --disable-gdu     \
            --disable-ldap    &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
