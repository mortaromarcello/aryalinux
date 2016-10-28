#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The UnZip package containsbr3ak <code class="filename">ZIP extraction utilities. These arebr3ak useful for extracting files from <code class="filename">ZIPbr3ak archives. <code class="filename">ZIP archives are createdbr3ak with PKZIP or Info-ZIP utilities, primarily in a DOSbr3ak environment.br3ak
#SECTION:general



#VER:unzip:60


NAME="unzip"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unzip/unzip60.tar.gz


URL=http://downloads.sourceforge.net/infozip/unzip60.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

convmv -f iso-8859-1 -t cp850 -r --nosmart --notest \
    <em class="replaceable"><code></path/to/unzipped/files></em>

convmv -f cp866 -t koi8-r -r --nosmart --notest \
    <em class="replaceable"><code></path/to/unzipped/files></em>

make -f unix/Makefile generic


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
