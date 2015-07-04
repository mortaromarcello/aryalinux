#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cups
#DEP:glib2
#DEP:ijs
#DEP:lcms2
#DEP:poppler
#DEP:qpdf
#DEP:libjpeg
#DEP:libpng
#DEP:libtiff
#DEP:gs
#DEP:gutenprint


cd $SOURCE_DIR

wget -nc https://www.openprinting.org/download/cups-filters/cups-filters-1.0.65.tar.xz


TARBALL=cups-filters-1.0.65.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:cups.service:org.cups.cupsd.service:g" utils/cups-browsed.service

sed -i "s:globalParams->getAntialias():gFalse:g" filter/pdftoopvp/OPVPOutputDev.cxx     &&
sed -i "/paperColor,g/s:gTrue,gFalse:gTrue:" filter/pdftoijs.cxx filter/pdftoraster.cxx &&
sed -i "/setAntialias/d" filter/pdftoopvp/pdftoopvp.cxx

./configure --prefix=/usr                   \
            --sysconfdir=/etc               \
            --localstatedir=/var            \
            --without-rcdir                 \
            --disable-static                \
            --with-gs-path=/usr/bin/gs      \
            --with-pdftops-path=/usr/bin/gs \
            --docdir=/usr/share/doc/cups-filters-1.0.65 &&
make

cat > 1434987998840.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
install -v -m644 utils/cups-browsed.service /lib/systemd/system/cups-browsed.service
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
systemctl enable cups-browsed
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cups-filters=>`date`" | sudo tee -a $INSTALLED_LIST