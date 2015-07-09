#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib
#DEP:cups
#DEP:giflib
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/files/BLFS/OpenJDK-1.8.0.31/OpenJDK-1.8.0.31-i686-bin.tar.xz


TARBALL=OpenJDK-1.8.0.31-i686-bin.tar.xz
DIRECTORY=OpenJDK-1.8.0.31-bin

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998779.sh << "ENDOFFILE"
install -v -dm755 /opt/OpenJDK-1.8.0.31-bin &&
mv -v * /opt/OpenJDK-1.8.0.31-bin         &&
chown -R root:root /opt/OpenJDK-1.8.0.31-bin
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh

cat > 1434987998779.sh << "ENDOFFILE"
cat > /etc/profile.d/java.sh << EOF
export CLASSPATH=.:/usr/share/java &&
export JAVA_HOME=/opt/OpenJDK-1.8.0.31-bin &&
export PATH="$PATH:/opt/OpenJDK-1.8.0.31-bin/bin"
EOF
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "java=>`date`" | sudo tee -a $INSTALLED_LIST