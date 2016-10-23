#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak QScintilla is a port tobr3ak Qt of <a class="ulink" href="http://www.scintilla.org/">Scintilla</a>. As well as featuresbr3ak found in standard text editing components, it includes featuresbr3ak especially useful when editing and debugging source code: languagebr3ak syntax styling, error indicators, code completion, call tips, codebr3ak folding, margins can contain markers like those used in debuggersbr3ak to indicate breakpoints and the current line, recordable macros,br3ak multiple views and, of course, printing.br3ak
#SECTION:lxqt

whoami > /tmp/currentuser

#REQ:chrpath
#REQ:qt5


#VER:QScintilla_gpl:2.9.3


NAME="qscintilla"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.9.3.tar.gz


URL=http://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.9.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
