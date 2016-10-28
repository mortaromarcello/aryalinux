#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The JUnit package contains abr3ak simple, open source framework to write and run repeatable tests. Itbr3ak is an instance of the xUnit architecture for unit testingbr3ak frameworks. JUnit features include assertions for testing expectedbr3ak results, test fixtures for sharing common test data, and testbr3ak runners for running tests.br3ak
#SECTION:general

#REQ:apache-ant
#REQ:unzip


#VER:hamcrest:1.3
#VER:junit.orig:4_4.11


NAME="junit"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz
wget -nc http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz


URL=https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
