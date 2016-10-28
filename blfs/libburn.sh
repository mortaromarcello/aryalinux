#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libburn is a library for writingbr3ak preformatted data onto optical media: CD, DVD and BD (Blu-Ray).br3ak
#SECTION:multimedia



#VER:libburn:1.4.6


NAME="libburn"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc http://files.libburnia-project.org/releases/libburn-1.4.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libburn/libburn-1.4.6.tar.gz


URL=http://files.libburnia-project.org/releases/libburn-1.4.6.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
