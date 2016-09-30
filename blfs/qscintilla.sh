#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:QScintilla_gpl:2.9.3

#REQ:chrpath
#REQ:qt5


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.9.3.tar.gz

wget -nc http://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.9.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd Qt4Qt5             &&
qmake qscintilla.pro  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv libqscintilla2.so.12.0.2 $QT5DIR/lib/libqt5scintilla2.so &&
ln -sfv libqscintilla2.so.12.0.2 $QT5DIR/lib/libqt5scintilla2.so.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d $QT5DIR/share/doc/QScintilla-2.9.3/html &&
install -v -m644    ../doc/html-Qt4Qt5/* \
                    $QT5DIR/share/doc/QScintilla-2.9.3/html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "qscintilla=>`date`" | sudo tee -a $INSTALLED_LIST

