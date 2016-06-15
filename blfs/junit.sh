#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:junit.orig:4_4.11
#VER:hamcrest:1.3

#REQ:apache-ant
#REQ:unzip


cd $SOURCE_DIR

URL=https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz

wget -nc http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '\@/docs/@a<arg value="-Xdoclint:none"/>' build.xml


tar -xf ../hamcrest-1.3.tgz                              &&
cp -v hamcrest-1.3/hamcrest-core-1.3{,-sources}.jar lib/ &&
ant populate-dist



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/{doc,java}/junit-4.11 &&
chown -R root:root .                                 &&
cp -v -R junit*/javadoc/*             /usr/share/doc/junit-4.11  &&
cp -v junit*/junit*.jar               /usr/share/java/junit-4.11 &&
cp -v hamcrest-1.3/hamcrest-core*.jar /usr/share/java/junit-4.11

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "junit=>`date`" | sudo tee -a $INSTALLED_LIST

