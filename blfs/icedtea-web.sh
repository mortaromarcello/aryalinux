#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The IcedTea-Web package containsbr3ak both a Java browser plugin, and abr3ak new webstart implementation, licensed under GPLV3.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:npapi-sdk
#REQ:openjdk
#REQ:java
#REQ:ojdk-conf
#REQ:epiphany
#REQ:firefox
#REQ:midori
#REQ:seamonkey
#OPT:libxslt
#OPT:mercurial


#VER:icedtea-web:1.6.2


NAME="icedtea-web"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc http://icedtea.classpath.org/download/source/icedtea-web-1.6.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz


URL=http://icedtea.classpath.org/download/source/icedtea-web-1.6.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=${JAVA_HOME}/jre    \
            --with-jdk-home=${JAVA_HOME} \
            --disable-docs               \
            --mandir=${JAVA_HOME}/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mandb -c /opt/jdk/man

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -Dm0644 itweb-settings.desktop /usr/share/applications/itweb-settings.desktop &&
install -v -Dm0644 javaws.png /usr/share/pixmaps/javaws.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -s ${JAVA_HOME}/jre/lib/IcedTeaPlugin.so /usr/lib/mozilla/plugins/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
