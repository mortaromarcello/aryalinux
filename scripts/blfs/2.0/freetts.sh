#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apache-ant
#DEP:sharutils


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/freetts/freetts-1.2.2-src.zip


TARBALL=freetts-1.2.2-src.zip
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

mkdir -pv 1434987998838
chmod -R a+rw 1434987998838
cp freetts-1.2.2-src.zip 1434987998838
cd 1434987998838
unzip $TARBALL


unzip -q freetts-1.2.2-src.zip -x META-INF/* &&
unzip -q freetts-1.2.2-tst.zip -x META-INF/*

sed -i 's/value="src/value="./' build.xml &&
cd lib      &&
sh jsapi.sh &&
cd ..       &&
ant

ant junit &&
cd tests &&
sh regression.sh &&
cd ..

cat > 1434987998838.sh << "ENDOFFILE"
install -v -m755 -d /opt/freetts-1.2.2/{lib,docs/{audio,images}} &&
install -v -m644 lib/*.jar /opt/freetts-1.2.2/lib                &&
install -v -m644 *.txt RELEASE_NOTES docs/*.{pdf,html,txt,sx{w,d}} \
                               /opt/freetts-1.2.2/docs           &&
install -v -m644 docs/audio/*  /opt/freetts-1.2.2/docs/audio     &&
install -v -m644 docs/images/* /opt/freetts-1.2.2/docs/images    &&
cp -v -R javadoc               /opt/freetts-1.2.2                &&
ln -v -s freetts-1.2.2 /opt/freetts
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh

cat > 1434987998838.sh << "ENDOFFILE"
cp -v -R bin    /opt/freetts-1.2.2        &&
install -v -m644 speech.properties $JAVA_HOME/jre/lib &&
cp -v -R tools  /opt/freetts-1.2.2        &&
cp -v -R mbrola /opt/freetts-1.2.2        &&
cp -v -R demo   /opt/freetts-1.2.2
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh

java -jar /opt/freetts/lib/freetts.jar \
    -text "This is a test of the FreeTTS speech synthesis system"

java -jar /opt/freetts/lib/freetts.jar -streaming \
    -text "This is a test of the FreeTTS speech synthesis system"


 
cd $SOURCE_DIR
 
echo "freetts=>`date`" | sudo tee -a $INSTALLED_LIST