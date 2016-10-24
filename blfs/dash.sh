#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak Dash is a POSIX compliant shell.br3ak It can be installed as /bin/sh or as the default shell for eitherbr3ak <code class="systemitem">root or a second user with a useridbr3ak of 0. It depends on fewer libraries than the Bash shell and is therefore less likely to bebr3ak affected by an upgrade problem or disk failure. Dash is also useful for checking that a scriptbr3ak is completely compatible with POSIX syntax.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser



#VER:dash:0.5.9.1


NAME="dash"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dash/dash-0.5.9.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dash/dash-0.5.9.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dash/dash-0.5.9.1.tar.gz || wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dash/dash-0.5.9.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dash/dash-0.5.9.1.tar.gz


URL=http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --bindir=/bin --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


ln -svf dash /bin/sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/shells << "EOF"
/bin/dash
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
