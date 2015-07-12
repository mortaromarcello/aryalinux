#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:libxml2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gstreamer/0.10/gstreamer-0.10.36.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gstreamer/0.10/gstreamer-0.10.36.tar.xz


TARBALL=gstreamer-0.10.36.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i  -e '/YYLEX_PARAM/d'                                       \
        -e '/parse-param.*scanner/i %lex-param { void *scanner }' \
            gst/parse/grammar.y &&

./configure --prefix=/usr    \
            --disable-static \
            --with-package-name="GStreamer 0.10.36 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make

cat > 1434987998832.sh << "ENDOFFILE"
make install &&
install -v -dm755   /usr/share/doc/gstreamer-0.10/design &&
install -v -m644 docs/design/*.txt \
                    /usr/share/doc/gstreamer-0.10/design &&

if [ -d /usr/share/doc/gstreamer-0.10/faq/html ]; then
    chown -rv root:root \
        /usr/share/doc/gstreamer-0.10/*/html
fi
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gstreamer=>`date`" | sudo tee -a $INSTALLED_LIST