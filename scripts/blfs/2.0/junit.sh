#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apache-ant
#DEP:unzip


cd $SOURCE_DIR

wget -nc https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz
wget -nc http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz


TARBALL=junit4_4.11.orig.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '\@/docs/@a<arg value="-Xdoclint:none"/>' build.xml

tar -xf ../hamcrest-1.3.tgz                              &&
cp -v hamcrest-1.3/hamcrest-core-1.3{,-sources}.jar lib/ &&
ant populate-dist

cat > 1434987998780.sh << "ENDOFFILE"
install -v -dm755 /usr/share/{doc,java}/junit-4.11 &&
chown -R root:root .                               &&

cp -rv junit*/javadoc/*               /usr/share/doc/junit-4.11  &&
cp -v junit*/junit*.jar               /usr/share/java/junit-4.11 &&
cp -v hamcrest-1.3/hamcrest-core*.jar /usr/share/java/junit-4.11
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

export CLASSPATH=$CLASSPATH:/usr/share/java/junit-4.11


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "junit=>`date`" | sudo tee -a $INSTALLED_LIST