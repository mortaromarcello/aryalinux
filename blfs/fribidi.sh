#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The FriBidi package is anbr3ak implementation of the <a class="ulink" href="http://www.unicode.org/reports/tr9/">Unicode Bidirectionalbr3ak Algorithm (BIDI)</a>. This is useful for supporting Arabic andbr3ak Hebrew alphabets in other packages.br3ak
#SECTION:general

#OPT:glib2


#VER:fribidi:0.19.7


NAME="fribidi"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fribidi/fribidi-0.19.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fribidi/fribidi-0.19.7.tar.bz2 || wget -nc http://fribidi.org/download/fribidi-0.19.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fribidi/fribidi-0.19.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fribidi/fribidi-0.19.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fribidi/fribidi-0.19.7.tar.bz2


URL=http://fribidi.org/download/fribidi-0.19.7.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&

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
