#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This package provides a library for learning linear classifiers forbr3ak large scale applications. It supports Support Vector Machines (SVM)br3ak with L2 and L1 loss, logistic regression, multi classbr3ak classification and also Linear Programming Machines (L1-regularizedbr3ak SVMs). Its computational complexity scales linearly with the numberbr3ak of training examples making it one of the fastest SVM solversbr3ak around.br3ak
#SECTION:general



#VER:v:210


NAME="liblinear"

wget -nc https://github.com/cjlin1/liblinear/archive/v210.tar.gz


URL=https://github.com/cjlin1/liblinear/archive/v210.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

wget -c https://github.com/cjlin1/liblinear/archive/v210.tar.gz \
     -O liblinear-210.tar.gz

make lib


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm644 linear.h /usr/include &&
install -vm755 liblinear.so.3 /usr/lib &&
ln -sfv liblinear.so.3 /usr/lib/liblinear.so
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
