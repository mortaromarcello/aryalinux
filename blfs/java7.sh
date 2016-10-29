#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

ARCH=$(uname -m)

if [ $ARCH == "x86_64" ]
then
	URL=http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-1.7.0.65-x86_64-bin.tar.xz
else
	URL=http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-1.7.0.65-i686-bin.tar.xz
fi

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sudo install -v -dm755 /opt/OpenJDK-1.7.0.65-bin &&
sudo mv -v * /opt/OpenJDK-1.7.0.65-bin         &&
sudo chown -R root:root /opt/OpenJDK-1.7.0.65-bin

sudo ln -sfnv OpenJDK-1.7.0.65-bin /opt/jdk

sudo tee /etc/profile.d/openjdk.sh << "EOF"
# Begin /etc/profile.d/openjdk.sh

# Set JAVA_HOME directory
JAVA_HOME=/opt/jdk

# Adjust PATH
pathappend $JAVA_HOME/bin

# Add to MANPATH
pathappend $JAVA_HOME/man MANPATH

# Make sure C and C++ compilers can find Java headers
pathappend $JAVA_HOME/include       C_INCLUDE_PATH
pathappend $JAVA_HOME/include/linux C_INCLUDE_PATH
pathappend $JAVA_HOME/include       CPLUS_INCLUDE_PATH
pathappend $JAVA_HOME/include/linux CPLUS_INCLUDE_PATH

# Auto Java CLASSPATH: Copy jar files to, or create symlinks in, the
# /usr/share/java directory. Note that having gcj jars with OpenJDK 8
# may lead to errors.

AUTO_CLASSPATH_DIR=/usr/share/java

pathprepend . CLASSPATH

for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
    pathappend $dir CLASSPATH
done

for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do
    pathappend $jar CLASSPATH
done

export JAVA_HOME
unset AUTO_CLASSPATH_DIR dir jar

# End /etc/profile.d/openjdk.sh
EOF

sudo tee -a /etc/man_db.conf << "EOF" &&
# Begin Java addition
MANDATORY_MANPATH     /opt/jdk/man
MANPATH_MAP           /opt/jdk/bin     /opt/jdk/man
MANDB_MAP             /opt/jdk/man     /var/cache/man/jdk
# End Java addition
EOF

sudo mkdir -p /var/cache/man
sudo mandb -c /opt/jdk/man

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
