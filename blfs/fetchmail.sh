#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Fetchmail package contains abr3ak mail retrieval program. It retrieves mail from remote mail serversbr3ak and forwards it to the local (client) machine's delivery system, sobr3ak it can then be read by normal mail user agents.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REC:openssl
#REC:procmail
#OPT:python2
#OPT:tk


#VER:fetchmail:6.3.26


NAME="fetchmail"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.at.gnucash.org/pub/infosys/mail/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz


URL=http://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.fetchmailrc << "EOF"
set logfile /var/log/fetchmail.log
set no bouncemail
set postmaster root
poll SERVERNAME :
 user <em class="replaceable"><code><username></em> pass <em class="replaceable"><code><password></em>;
 mda "/usr/bin/procmail -f %F -d %T";
EOF
chmod -v 0600 ~/.fetchmailrc




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
