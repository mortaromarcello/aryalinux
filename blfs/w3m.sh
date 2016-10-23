#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak w3m is primarily a pager but itbr3ak can also be used as a text-mode WWW browser.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:gc
#OPT:gpm
#OPT:openssl
#OPT:imlib2
#OPT:gtk2
#OPT:gdk-pixbuf
#OPT:compface


#VER:w3m:0.5.3


NAME="w3m"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc http://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/w3m/w3m-0.5.3-bdwgc72-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/w3m-0.5.3-bdwgc72-1.patch


URL=http://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../w3m-0.5.3-bdwgc72-1.patch &&
sed -i 's/file_handle/file_foo/' istream.{c,h} &&
sed -i 's#gdk-pixbuf-xlib-2.0#& x11#' configure &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D doc/keymap.default /etc/w3m/keymap &&
install -v -m644    doc/menu.default /etc/w3m/menu &&
install -v -m755 -d /usr/share/doc/w3m-0.5.3 &&
install -v -m644    doc/{HISTORY,READ*,keymap.*,menu.*,*.html} \
                    /usr/share/doc/w3m-0.5.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
