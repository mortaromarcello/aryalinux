#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Procmail package contains anbr3ak autonomous mail processor. This is useful for filtering and sortingbr3ak incoming mail.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser



#VER:procmail:3.22


NAME="procmail"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc ftp://ftp.ucsb.edu/pub/mirrors/procmail/procmail-3.22.tar.gz


URL=http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i 's/getline/get_line/' src/*.[ch] &&
make LOCKINGTEST=/tmp MANDIR=/usr/share/man install &&
make install-suid

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
