#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://mirror.fibergrid.in/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

sudo tar -xf $TARBALL -C /opt/
sudo ln -s /opt/$DIRECTORY /opt/mvn
sudo tee /etc/profile.d/mvn.sh<<"EOF"
export M2_HOME=/opt/mvn
pathappend $M2_HOME/bin
EOF

cd $SOURCE_DIR

echo "maven=>`date`" | sudo tee -a $INSTALLED_LIST


