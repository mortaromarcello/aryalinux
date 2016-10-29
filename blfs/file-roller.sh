#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak File Roller is an archive managerbr3ak for GNOME with support for tar,br3ak bzip2, gzip, zip, jar, compress, lzop and many other archivebr3ak formats.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="file-roller"

#REQ:gtk3
#REQ:itstool
#REC:cpio
#REC:desktop-file-utils
#REC:json-glib
#REC:libarchive
#REC:libnotify
#REC:nautilus
#OPT:unrar
#OPT:unzip
#OPT:zip


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/file-roller/file-roller-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/file-roller/3.22/file-roller-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/file-roller/file-roller-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/file-roller/file-roller-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/file-roller/3.22/file-roller-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/file-roller/file-roller-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/file-roller/file-roller-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/file-roller/3.22/file-roller-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr         \
            --disable-packagekit  \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 0755 /usr/libexec/file-roller/isoinfo.sh

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
