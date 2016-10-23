#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The dvd+rw-tools package containsbr3ak several utilities to master the DVD media, both +RW/+R and -R[W].br3ak The principle tool is <span class="command"><strong>growisofs</strong> which provides a way tobr3ak both lay down <span class="strong"><strong>and</strong> growbr3ak an ISO9660 file system on (as well as to burn an arbitrarybr3ak pre-mastered image to) all supported DVD media. This is useful forbr3ak creating a new DVD or adding to an existing image on a partiallybr3ak burned DVD.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:dvd+rw-tools:7.1


NAME="dvd-rw-tools"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz


URL=http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/stdlib/a #include <limits.h>' transport.hxx &&
sed -i 's#mkisofs"#xorrisofs"#' growisofs.c &&
sed -i 's#mkisofs#xorrisofs#;s#MKISOFS#XORRISOFS#' growisofs.1 &&
make all rpl8 btcflash



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install &&
install -v -m644 -D index.html \
    /usr/share/doc/dvd+rw-tools-7.1/index.html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
