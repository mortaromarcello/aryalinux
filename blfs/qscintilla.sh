#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak QScintilla is a port tobr3ak Qt of <a class=\"ulink\" href=\"http://www.scintilla.org/\">Scintilla</a>. As well as featuresbr3ak found in standard text editing components, it includes featuresbr3ak especially useful when editing and debugging source code: languagebr3ak syntax styling, error indicators, code completion, call tips, codebr3ak folding, margins can contain markers like those used in debuggersbr3ak to indicate breakpoints and the current line, recordable macros,br3ak multiple views and, of course, printing.br3ak"
SECTION="lxqt"
VERSION=2.9.3
NAME="qscintilla"

#REQ:chrpath
#REQ:qt5


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.9.3.tar.gz

if [ ! -z $URL ]
then
wget -nc http://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.9.3.tar.gz

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

cd Qt4Qt5             &&
qmake qscintilla.pro  &&
make "-j`nproc`" || make



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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
