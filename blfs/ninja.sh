#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:v:1.7.1

#REQ:python2
#OPT:emacs
#OPT:asciidoc
#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/ninja-build/ninja/archive/v1.7.1.tar.gz

wget -nc https://github.com/ninja-build/ninja/archive/v1.7.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

wget https://github.com/ninja-build/ninja/archive/v1.7.1.tar.gz \
     -O ninja-1.7.1.tar.gz


./configure.py --bootstrap


emacs -Q --batch -f batch-byte-compile misc/ninja-mode.el


./configure.py &&
./ninja ninja_test &&
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm755 ninja /usr/bin/ &&
install -vDm644 misc/ninja.vim \
                /usr/share/vim/vim74/syntax/ninja.vim &&
install -vDm644 misc/bash-completion \
                /usr/share/bash-completion/completions/ninja &&
install -vDm644 misc/zsh-completion \
                /usr/share/zsh/site-functions/_ninja

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vDm644 misc/ninja-mode.el \
                /usr/share/emacs/site-lisp/ninja-mode.el
install -vDm644 misc/ninja-mode.elc \
                /usr/share/emacs/site-lisp/ninja-mode.elc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ninja=>`date`" | sudo tee -a $INSTALLED_LIST

