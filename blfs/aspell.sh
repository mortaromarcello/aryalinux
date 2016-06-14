#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:aspell:0.60.6.1

#REQ:general_which


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz

wget -nc https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

cat > aspell.patch <<"ENDOFFILE"
From https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=180565
--- interfaces/cc/aspell.h.orig	2011-07-02 17:53:27.000000000 -0400
+++ interfaces/cc/aspell.h	2015-07-29 11:23:32.000000000 -0400
@@ -237,6 +237,7 @@
 /******************************** errors ********************************/
 
 
+#ifndef ASPELL_ERRORS__HPP
 extern const struct AspellErrorInfo * const aerror_other;
 extern const struct AspellErrorInfo * const aerror_operation_not_supported;
 extern const struct AspellErrorInfo * const   aerror_cant_copy;
@@ -322,6 +323,7 @@
 extern const struct AspellErrorInfo * const   aerror_bad_magic;
 extern const struct AspellErrorInfo * const aerror_expression;
 extern const struct AspellErrorInfo * const   aerror_invalid_expression;
+#endif
 
 
 /******************************* speller *******************************/
--- prog/aspell.cpp.orig	2011-07-04 05:13:58.000000000 -0400
+++ prog/aspell.cpp	2015-07-29 11:22:57.000000000 -0400
@@ -25,6 +25,7 @@
 # include <langinfo.h>
 #endif
 
+#include "errors.hpp"
 #include "aspell.h"
 
 #ifdef USE_FILE_INO
@@ -40,7 +41,6 @@
 #include "convert.hpp"
 #include "document_checker.hpp"
 #include "enumeration.hpp"
-#include "errors.hpp"
 #include "file_util.hpp"
 #include "fstream.hpp"
 #include "info.hpp"
--- prog/checker_string.hpp.orig	2011-07-02 17:09:09.000000000 -0400
+++ prog/checker_string.hpp	2015-07-29 11:24:50.000000000 -0400
@@ -6,6 +6,7 @@
 
 #include <stdio.h>
 
+#include "errors.hpp"
 #include "aspell.h"
 
 #include "vector.hpp"
ENDOFFILE

patch -Np0 -i aspell.patch

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfvn aspell-0.60 /usr/lib/aspell &&
install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&
install -v -m644 manual/aspell.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell.html &&
install -v -m644 manual/aspell-dev.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell-dev.html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/ispell /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/spell /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "aspell=>`date`" | sudo tee -a $INSTALLED_LIST

