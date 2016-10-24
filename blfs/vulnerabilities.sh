#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak All software has bugs. Sometimes, a bug can be exploited, forbr3ak example to allow users to gain enhanced privileges (perhaps gainingbr3ak a root shell, or simply accessing or deleting other user's files),br3ak or to allow a remote site to crash an application (denial ofbr3ak service), or for theft of data. These bugs are labelled asbr3ak vulnerabilities.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser





NAME="vulnerabilities"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser



cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
