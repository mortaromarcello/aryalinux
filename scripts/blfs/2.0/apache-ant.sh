#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:java#java-bin
#DEP:openjdk
#DEP:glib2


cd $SOURCE_DIR

wget -nc http://archive.apache.org/dist/ant/source/apache-ant-1.9.4-src.tar.bz2
wget -nc http://anduin.linuxfromscratch.org/sources/other/junit-4.11.jar
wget -nc http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz


TARBALL=apache-ant-1.9.4-src.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xvf ../hamcrest-1.3.tgz &&
cp -v ../junit-4.11.jar \
      hamcrest-1.3/hamcrest-core-1.3.jar lib/optional

tar -xvf ../apache-ant-1.9.4-manual.tar.bz2

cat > 1434987998780.sh << "ENDOFFILE"
./build.sh -Ddist.dir=/opt/ant-1.9.4 dist &&
ln -sfv ant-1.9.4 /opt/ant
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
install -v -dm755 /opt/ant-1.9.4/docs &&
cp -rv apache-ant-1.9.4/* /opt/ant-1.9.4/docs
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "apache-ant=>`date`" | sudo tee -a $INSTALLED_LIST