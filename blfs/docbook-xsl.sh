#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:docbook-xsl:1.79.1
#VER:docbook-xsl-doc:1.79.1

#REC:libxml2
#OPT:apache-ant
#OPT:libxslt
#OPT:python2
#OPT:python3
#OPT:ruby
#OPT:zip


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/docbook/docbook-xsl-1.79.1.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-xsl-doc-1.79.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-xsl-doc-1.79.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook/docbook-xsl-doc-1.79.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-xsl-doc-1.79.1.tar.bz2 || wget -nc http://downloads.sourceforge.net/docbook/docbook-xsl-doc-1.79.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-xsl-doc-1.79.1.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook/docbook-xsl-1.79.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-xsl-1.79.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-xsl-1.79.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-xsl-1.79.1.tar.bz2 || wget -nc http://downloads.sourceforge.net/docbook/docbook-xsl-1.79.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-xsl-1.79.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../docbook-xsl-doc-1.79.1.tar.bz2 --strip-components=1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-1.79.1 &&
cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    /usr/share/xml/docbook/xsl-stylesheets-1.79.1 &&
ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-1.79.1/VERSION.xsl &&
install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-1.79.1/README.txt &&
install -v -m644    RELEASE-NOTES* NEWS* \
                    /usr/share/doc/docbook-xsl-1.79.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v -R doc/* /usr/share/doc/docbook-xsl-1.79.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/1.79.1" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.1" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/1.79.1" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.1" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.1" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.1" \
    /etc/xml/catalog

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "docbook-xsl=>`date`" | sudo tee -a $INSTALLED_LIST

