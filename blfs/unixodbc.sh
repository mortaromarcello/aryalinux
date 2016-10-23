#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The unixODBC package is an Openbr3ak Source ODBC (Open DataBase Connectivity) sub-system and an ODBC SDKbr3ak for Linux, Mac OSX, and UNIX. ODBC is an open specification forbr3ak providing application developers with a predictable API with whichbr3ak to access data sources. Data sources include optional SQL Serversbr3ak and any data source with an ODBC Driver. unixODBC contains the following componentsbr3ak used to assist with the manipulation of ODBC data sources: a driverbr3ak manager, an installer library and command line tool, command linebr3ak tools to help install a driver and work with SQL, drivers andbr3ak driver setup libraries.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:pth


#VER:unixODBC:2.3.4


NAME="unixodbc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.4.tar.gz


URL=ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --sysconfdir=/etc/unixODBC &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find doc -name "Makefile*" -delete                &&
chmod 644 doc/{lst,ProgrammerManual/Tutorial}/*   &&
install -v -m755 -d /usr/share/doc/unixODBC-2.3.4 &&
cp      -v -R doc/* /usr/share/doc/unixODBC-2.3.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
