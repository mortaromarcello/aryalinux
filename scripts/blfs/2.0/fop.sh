#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apache-ant


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-1.1-src.tar.gz


TARBALL=fop-1.1-src.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998843.sh << "ENDOFFILE"
case `uname -m` in
  i?86)
    tar -xf ../jai-1_1_3-lib-linux-i586.tar.gz
    cp -v jai-1_1_3/lib/{jai*,mlibwrapper_jai.jar} $JAVA_HOME/jre/lib/ext/
    cp -v jai-1_1_3/lib/libmlib_jai.so             $JAVA_HOME/jre/lib/i386/
    ;;

  x86_64)
    tar -xf ../jai-1_1_3-lib-linux-amd64.tar.gz
    cp -v jai-1_1_3/lib/{jai*,mlibwrapper_jai.jar} $JAVA_HOME/jre/lib/ext/
    cp -v jai-1_1_3/lib/libmlib_jai.so             $JAVA_HOME/jre/lib/amd64/
    ;;
esac
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh

sed -i '\@</javad@i<arg value="-Xdoclint:none"/>' build.xml

ant compile &&
ant jar-main &&
ant javadocs &&
mv build/javadocs .

ant docs

cat > 1434987998843.sh << "ENDOFFILE"
install -v -d -m755                                     /opt/fop-1.1 &&
cp -v  KEYS LICENSE NOTICE README                       /opt/fop-1.1 &&
cp -va build conf examples fop* javadocs lib status.xml /opt/fop-1.1 &&

ln -v -sf fop-1.1 /opt/fop
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh

cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<em class="replaceable"><code><RAM_Installed></em>m"
FOP_HOME="/opt/fop"
EOF


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fop=>`date`" | sudo tee -a $INSTALLED_LIST