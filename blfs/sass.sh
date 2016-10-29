#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:ruby

cd $SOURCE_DIR

NAME="sass"

sudo gem install sass

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
