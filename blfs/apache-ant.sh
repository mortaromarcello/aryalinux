#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Apache Ant package is abr3ak Java-based build tool. In theory,br3ak it is like the <span class="command"><strong>make</strong>br3ak command, but without <span class="command"><strong>make</strong>'s wrinkles. Ant is different. Instead of a model that isbr3ak extended with shell-based commands, Ant is extended using Java classes. Instead of writing shellbr3ak commands, the configuration files are XML-based, calling out abr3ak target tree that executes various tasks. Each task is run by anbr3ak object that implements a particular task interface.br3ak
#SECTION:general

#REQ:java#java-bin
#REQ:openjdk
#REQ:glib2


#VER:apache-ant-src:1.9.7
#VER:hamcrest:1.3


NAME="apache-ant"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2 || wget -nc https://archive.apache.org/dist/ant/source/apache-ant-1.9.7-src.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apache-ant/apache-ant-1.9.7-src.tar.bz2
wget -nc http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz


URL=https://archive.apache.org/dist/ant/source/apache-ant-1.9.7-src.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

tar -xvf ../hamcrest-1.3.tgz &&
cp -v ../junit-4.11.jar \
      hamcrest-1.3/hamcrest-core-1.3.jar lib/optional


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./build.sh -Ddist.dir=/opt/ant-1.9.7 dist &&
ln -v -sfn ant-1.9.7 /opt/ant
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/profile.d/extrapaths.sh << EOF

# Begin Apache-ant addition

pathappend /opt/ant/bin
export ANT_HOME=/opt/ant

# End Apache-ant addition

EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
