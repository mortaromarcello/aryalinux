#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR


echo "mitkrb-config=>`date`" | sudo tee -a $INSTALLED_LIST
