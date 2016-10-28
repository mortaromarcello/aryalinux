#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The time utility is a program thatbr3ak measures many of the CPU resources, such as time and memory, thatbr3ak other programs use. The GNU version can format the output inbr3ak arbitrary ways by using a printf-style format string to includebr3ak various resource measurements.br3ak
#SECTION:general



#VER:time:1.7


NAME="time"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/time/time-1.7.tar.gz || wget -nc http://ftp.gnu.org/gnu/time/time-1.7.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/time/time-1.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/time/time-1.7.tar.gz


URL=http://ftp.gnu.org/gnu/time/time-1.7.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i 's/$(ACLOCAL)//' Makefile.in                                            &&
sed -i 's/lu", ptok ((UL) resp->ru.ru_maxrss)/ld", resp->ru.ru_maxrss/' time.c &&

./configure --prefix=/usr --infodir=/usr/share/info                            &&
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
