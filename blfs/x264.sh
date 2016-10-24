#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak x264 package provides a librarybr3ak for encoding video streams into the H.264/MPEG-4 AVC format.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REC:yasm


#VER:x264-snapshot-20160827-stable:2245


NAME="x264"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2


URL=http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20160827-2245-stable.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --enable-shared \
            --disable-cli &&
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
