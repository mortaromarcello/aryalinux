#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak FAAD2 is a decoder for a lossybr3ak sound compression scheme specified in MPEG-2 Part 7 and MPEG-4 Partbr3ak 3 standards and known as Advanced Audio Coding (AAC).br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:faad2:2.7


NAME="faad2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/faad2-2.7-mp4ff-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/faad2/faad2-2.7-mp4ff-1.patch


URL=http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../faad2-2.7-mp4ff-1.patch &&
sed -i "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" configure.in &&
sed -i "s:man_MANS:man1_MANS:g" frontend/Makefile.am         &&
autoreconf -fi &&
./configure --prefix=/usr --disable-static &&
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
