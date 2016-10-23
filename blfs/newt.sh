#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Newt is a programming library forbr3ak color text mode, widget based user interfaces. It can be used tobr3ak add stacked windows, entry widgets, checkboxes, radio buttons,br3ak labels, plain text fields, scrollbars, etc., to text mode userbr3ak interfaces. Newt is based on thebr3ak S-Lang library.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:popt
#REQ:slang
#REC:gpm
#OPT:python2
#OPT:python3


#VER:newt:0.52.19


NAME="newt"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/newt/newt-0.52.19.tar.gz || wget -nc http://fedorahosted.org/releases/n/e/newt/newt-0.52.19.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/newt/newt-0.52.19.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/newt/newt-0.52.19.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/newt/newt-0.52.19.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/newt/newt-0.52.19.tar.gz


URL=http://fedorahosted.org/releases/n/e/newt/newt-0.52.19.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's/^LIBNEWT =/#&/' \
    -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
    -e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
    -i Makefile.in                           &&
./configure --prefix=/usr --with-gpm-support &&
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
