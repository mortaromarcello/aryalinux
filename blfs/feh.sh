#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak feh is a fast, lightweight imagebr3ak viewer which uses Imlib2. It is commandline-driven and supportsbr3ak multiple images through slideshows, thumbnail browsing or multiplebr3ak windows, and montages or index prints (using TrueType fonts tobr3ak display file info). Advanced features include fast dynamic zooming,br3ak progressive loading, loading via HTTP (with reload support forbr3ak watching webcams), recursive file opening (slideshow of a directorybr3ak hierarchy), and mouse wheel/keyboard control.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:libpng
#REQ:imlib2
#REQ:giflib
#REC:curl
#OPT:libexif
#OPT:libjpeg
#OPT:imagemagick
#OPT:perl-modules#perl-test-command


#VER:feh:2.17.1


NAME="feh"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.17.1.tar.bz2 || wget -nc http://feh.finalrewind.org/feh-2.17.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.17.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.17.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/feh/feh-2.17.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.17.1.tar.bz2


URL=http://feh.finalrewind.org/feh-2.17.1.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "s:doc/feh:&-2.17.1:" config.mk &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
