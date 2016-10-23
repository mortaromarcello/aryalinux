#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The original libraries were simply an archive of routines frombr3ak which the required routines were extracted and linked into thebr3ak executable program. These are described as static librariesbr3ak (libfoo.a). On some old operating systems they are the only typebr3ak available.br3ak
#SECTION:introduction

whoami > /tmp/currentuser





NAME="libraries"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser



cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
