#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://mirror.fibergrid.in/apache/tomcat/tomcat-9/v9.0.0.M8/bin/apache-tomcat-9.0.0.M8.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

sudo tar -xf $TARBALL -C /opt/
sudo ln -s /opt/$DIRECTORY /opt/tomcat
sudo tee /etc/profile.d/tomcat.sh<<"EOF"
export CATALINA_HOME=/opt/tomcat
pathappend $M2_HOME/bin
EOF

cd $SOURCE_DIR

echo "tomcat9=>`date`" | sudo tee -a $INSTALLED_LIST


