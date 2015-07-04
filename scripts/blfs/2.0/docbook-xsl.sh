#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxml2


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/docbook/docbook-xsl-1.78.1.tar.bz2
wget -nc http://downloads.sourceforge.net/docbook/docbook-xsl-doc-1.78.1.tar.bz2


TARBALL=docbook-xsl-1.78.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../docbook-xsl-doc-1.78.1.tar.bz2 --strip-components=1

cat > 1434987998842.sh << "ENDOFFILE"
install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-1.78.1 &&

cp -v -R VERSION common eclipse epub extensions fo highlighting html \
         htmlhelp images javahelp lib manpages params profiling \
         roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 \
    /usr/share/xml/docbook/xsl-stylesheets-1.78.1 &&

ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-1.78.1/VERSION.xsl &&

install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-1.78.1/README.txt &&
install -v -m644    RELEASE-NOTES* NEWS* \
                    /usr/share/doc/docbook-xsl-1.78.1
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
cp -v -R doc/* /usr/share/doc/docbook-xsl-1.78.1
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/1.78.1" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/1.78.1" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "docbook-xsl=>`date`" | sudo tee -a $INSTALLED_LIST