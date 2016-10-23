#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:introduction

whoami > /tmp/currentuser



#VER:debtargz:2
#VER:rpmtargz:2


NAME="beyond"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.linuxfromscratch.org/deb2targz.tar.bz2
wget -nc http://downloads.linuxfromscratch.org/rpm2targz.tar.bz2


URL=http://downloads.linuxfromscratch.org/deb2targz.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser



cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST