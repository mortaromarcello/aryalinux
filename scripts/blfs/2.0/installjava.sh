#!/bin/bash

set -e
set +h

. /etc/alps/installer-functions

echo "Installing Java Development System..."
echo ""
echo "Downloading JDK1.8..."

URL="http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"
wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $URL

TAR=`echo $URL | rev | cut -d/ -f1 | rev`
DIR=`tar -tf $TAR | cut -d/ -f1 | uniq`

tar -xf $TAR
sudo mv $DIR /opt

sudo tee /etc/profile.d/java.sh << EOF
pathappend /opt/$DIR/bin PATH
EOF

export PATH=$PATH:/opt/$DIR/bin

if javac &> /dev/null
then
	echo "JDK installed successfully"
fi
