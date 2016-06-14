#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fetchmail:6.3.26

#REC:openssl
#REC:procmail
#OPT:python2
#OPT:tk


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc ftp://ftp.at.gnucash.org/pub/infosys/mail/fetchmail/fetchmail-6.3.26.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make "-j`nproc`"



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

sudo rm -rf $DIRECTORY
echo "fetchmail=>`date`" | sudo tee -a $INSTALLED_LIST

