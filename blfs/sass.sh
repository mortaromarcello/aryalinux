#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:ruby

cd $SOURCE_DIR

PACKAGE_NAME="sass"

sudo gem install sass

cd $SOURCE_DIR

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
