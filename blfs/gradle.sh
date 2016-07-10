#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:gradle--bin:2.14

cd $SOURCE_DIR

URL=https://services.gradle.org/distributions/gradle-2.14-bin.zip
wget -nc $URL
TARBALL=gradle-2.14-bin.zip
DIRECTORY=gradle-2.14

sudo unzip $TARBALL -d /opt/
sudo ln -s /opt/$DIRECTORY /opt/gradle
sudo tee /etc/profile.d/gradle.sh<<"EOF"
export GRADLE_HOME=/opt/gradle
pathappend $M2_HOME/bin
EOF

cd $SOURCE_DIR

echo "gradle=>`date`" | sudo tee -a $INSTALLED_LIST


