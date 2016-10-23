#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The CDParanoia package contains abr3ak CD audio extraction tool. This is useful for extractingbr3ak <code class="filename">.wav files from audio CDs. A CDDAbr3ak capable CDROM drive is needed. Practically all drives supported bybr3ak Linux can be used.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:cdparanoia-III-.src:10.2


NAME="cdparanoia"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/cdparanoia-III-10.2-gcc_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/cdparanoia/cdparanoia-III-10.2-gcc_fixes-1.patch


URL=http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../cdparanoia-III-10.2-gcc_fixes-1.patch &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libcdda_*.so.0.10.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
