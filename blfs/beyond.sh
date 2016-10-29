#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="%DESCRIPTION%"
SECTION="introduction"
VERSION=2
NAME="beyond"



wget -nc http://downloads.linuxfromscratch.org/deb2targz.tar.bz2
wget -nc http://downloads.linuxfromscratch.org/rpm2targz.tar.bz2


URL=http://downloads.linuxfromscratch.org/deb2targz.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
