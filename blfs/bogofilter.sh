#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak TheBogofilter application is abr3ak mail filter that classifies mail as spam or ham (non-spam) by abr3ak statistical analysis of the message's header and content (body).br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:db
#REC:gsl
#OPT:sqlite


#VER:bogofilter:1.2.4


NAME="bogofilter"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://downloads.sourceforge.net/bogofilter/bogofilter-1.2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bogofilter/bogofilter-1.2.4.tar.gz


URL=http://downloads.sourceforge.net/bogofilter/bogofilter-1.2.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc/bogofilter &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
