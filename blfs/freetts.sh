#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:freetts-src:1.2.2
#VER:freetts-tst:1.2.2

#REQ:apache-ant
#REQ:sharutils


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/freetts/freetts-1.2.2-src.zip

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc http://downloads.sourceforge.net/freetts/freetts-1.2.2-src.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc http://downloads.sourceforge.net/freetts/freetts-1.2.2-tst.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=''
unzip_dirname $TARBALL DIRECTORY

unzip_file $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /opt/freetts-1.2.2/{lib,docs/{audio,images}} &&
install -v -m644 lib/*.jar /opt/freetts-1.2.2/lib                &&
install -v -m644 *.txt RELEASE_NOTES docs/*.{pdf,html,txt,sx{w,d}} \
                               /opt/freetts-1.2.2/docs           &&
install -v -m644 docs/audio/*  /opt/freetts-1.2.2/docs/audio     &&
install -v -m644 docs/images/* /opt/freetts-1.2.2/docs/images    &&
cp -v -R javadoc               /opt/freetts-1.2.2                &&
ln -v -s freetts-1.2.2 /opt/freetts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v -R bin    /opt/freetts-1.2.2        &&
install -v -m644 speech.properties $JAVA_HOME/jre/lib &&
cp -v -R tools  /opt/freetts-1.2.2        &&
cp -v -R mbrola /opt/freetts-1.2.2        &&
cp -v -R demo   /opt/freetts-1.2.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


java -jar /opt/freetts/lib/freetts.jar \
     -text "This is a test of the FreeTTS speech synthesis system"


java -jar /opt/freetts/lib/freetts.jar -streaming \
     -text "This is a test of the FreeTTS speech synthesis system"


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "freetts=>`date`" | sudo tee -a $INSTALLED_LIST

