#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Tidy HTML5 package contains abr3ak command line tool and libraries used to read HTML, XHTML and XMLbr3ak files and write cleaned up markup. It detects and corrects manybr3ak common coding errors and strives to produce visually equivalentbr3ak markup that is both W3C compliant and compatible with mostbr3ak browsers.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#REC:libxslt
#OPT:doxygen


#VER:tidy-html5:5.2.0


NAME="tidy-html5"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz


URL=https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

wget -c https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz \
     -O tidy-html5-5.2.0.tar.gz


cd build/cmake &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_TAB2SPACE=ON        \
      ../..    &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 tab2space /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST