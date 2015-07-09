#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:npapi-sdk
#DEP:openjdk
#DEP:java


cd $SOURCE_DIR

wget -nc http://icedtea.classpath.org/download/source/icedtea-web-1.5.2.tar.gz


TARBALL=icedtea-web-1.5.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=${JAVA_HOME}/jre    \
            --with-jdk-home=${JAVA_HOME} \
            --disable-docs               \
            --mandir=${JAVA_HOME}/man &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install &&
mandb -c /opt/jdk/man
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh

cat > 1434987998829.sh << "ENDOFFILE"
install -v -Dm644 itweb-settings.desktop /usr/share/applications/itweb-settings.desktop &&
install -v -Dm644 javaws.png /usr/share/pixmaps/javaws.png
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh

cat > 1434987998829.sh << "ENDOFFILE"
ln -sfv ${JAVA_HOME}/jre/lib/IcedTeaPlugin.so /usr/lib/mozilla/plugins/
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "icedtea-web=>`date`" | sudo tee -a $INSTALLED_LIST