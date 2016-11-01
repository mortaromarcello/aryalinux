#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak TheBogofilter application is abr3ak mail filter that classifies mail as spam or ham (non-spam) by abr3ak statistical analysis of the message's header and content (body).br3ak"
SECTION="general"
VERSION=1.2.4
NAME="bogofilter"

#REQ:db
#REC:gsl
#OPT:sqlite


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/bogofilter/bogofilter-1.2.4.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://downloads.sourceforge.net/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc/bogofilter &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
