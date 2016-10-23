#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The rep-gtk package contains abr3ak Lisp and GTK binding. This is useful for extendingbr3ak GTK-2 and GDK libraries with Lisp. Starting at rep-gtk-0.15, the package contains thebr3ak bindings to GTK and uses the samebr3ak instructions. Both can be installed, if needed.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:gtk2
#REQ:librep


#VER:rep-gtk_:0.90.8.3


NAME="rep-gtk"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz


URL=http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
