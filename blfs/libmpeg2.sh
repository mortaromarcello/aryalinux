#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libmpeg2 package contains abr3ak library for decoding MPEG-2 and MPEG-1 video streams. The librarybr3ak is able to decode all MPEG streams that conform to certainbr3ak restrictions: “<span class="quote">constrainedbr3ak parameters” for MPEG-1, and “<span class="quote">main profile” for MPEG-2. This is useful forbr3ak programs and applications needing to decode MPEG-2 and MPEG-1 videobr3ak streams.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:sdl
#OPT:xorg-server


#VER:libmpeg2:0.5.1


NAME="libmpeg2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/libmpeg2-0.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz


URL=http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/static const/static/' libmpeg2/idct_mmx.c &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/mpeg2dec-0.5.1 &&
install -v -m644 README doc/libmpeg2.txt \
                    /usr/share/doc/mpeg2dec-0.5.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
