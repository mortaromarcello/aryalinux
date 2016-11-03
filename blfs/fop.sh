#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The FOP (Formatting Objectsbr3ak Processor) package contains a print formatter driven by XSLbr3ak formatting objects (XSL-FO). It is a Java application that reads a formattingbr3ak object tree and renders the resulting pages to a specified output.br3ak Output formats currently supported include PDF, PCL, PostScript,br3ak SVG, XML (area tree representation), print, AWT, MIF and ASCIIbr3ak text. The primary output target is PDF.br3ak"
SECTION="pst"
VERSION=2.1
NAME="fop"

#REQ:apache-ant
#OPT:junit
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.1-src.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fop/fop-2.1-src.tar.gz || wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.1-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fop/fop-2.1-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fop/fop-2.1-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fop/fop-2.1-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fop/fop-2.1-src.tar.gz
wget -nc http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-i586.tar.gz
wget -nc http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/fop-2.1-listNPE-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/fop/fop-2.1-listNPE-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i '\@</javad@i<arg value="-Xdoclint:none"/>' build.xml


patch -Np1 -i ../fop-2.1-listNPE-1.patch &&
ant compile &&
ant jar-main &&
ant javadocs &&
mv build/javadocs .



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755                          /opt/fop-2.1 &&
cp -v  KEYS LICENSE NOTICE README            /opt/fop-2.1 &&
cp -va build conf examples fop* javadocs lib /opt/fop-2.1 &&
ln -v -sf fop-2.1 /opt/fop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<em class="replaceable"><code><RAM_Installed></em>m"
FOP_HOME="/opt/fop"
EOF




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
