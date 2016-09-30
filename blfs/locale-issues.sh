#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

find /usr/share/man -type f | xargs checkman.sh


cd $SOURCE_DIR

echo "locale-issues=>`date`" | sudo tee -a $INSTALLED_LIST

