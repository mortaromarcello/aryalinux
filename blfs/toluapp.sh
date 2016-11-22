#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="toluapp"
VERSION=SVN
DESCRIPTION="tolua++ is an extension of toLua, a tool to integrate C/C++ code with Lua"

#REQ:lua
#REQ:cmake

cd $SOURCE_DIR
URL="https://github.com/LuaDist/toluapp/archive/master.zip"
if [ ! -z $(echo $URL | grep "/master.zip$") ] && [ ! -f $NAME-master.zip ]; then
	wget -nc $URL -O $NAME-master.zip
	TARBALL=$NAME-master.zip
elif [ ! -z $(echo $URL | grep "/master.zip$") ] && [ -f $NAME-master.zip ]; then
	echo "Tarball already downloaded. Skipping."
	TARBALL=$NAME-master.zip
else
	wget -nc $URL
	TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
fi
DIRECTORY=$(unzip -l $TARBALL | grep "/" | rev | tr -s ' ' | cut -d ' ' -f1 | rev | cut -d/ -f1 | uniq)
unzip -o $TARBALL
cd $DIRECTORY

cat > config_linux.py <<"EOF"
## This is the linux configuration file
# use 'scons -h' to see the list of command line options available

# Compiler flags (based on Debian's installation of lua)
#LINKFLAGS = ['-g']
CCFLAGS = ['-I/usr/include', '-O2', '-ansi', '-Wall', '-fPIC']
#CCFLAGS = ['-I/usr/include/lua50', '-g']

# this is the default directory for installation. Files will be installed on
# <prefix>/bin, <prefix>/lib and <prefix>/include when you run 'scons install'
#
# You can also specify this directory on the command line with the 'prefix'
# option
#
# You can see more 'generic' options for POSIX systems on config_posix.py

prefix = '/usr'

# libraries (based on Debian's installation of lua)
LIBS = ['lua', 'dl', 'm']
EOF

cat > custom-5.1.py <<"EOF"
CCFLAGS = ['-I/usr/include', '-O2', '-ansi', '-fPIC', '-Wall']
#LIBPATH = ['/usr/local/lib']
LIBS = ['lua', 'dl', 'm']
prefix = '/mingw'
#build_dev=1
tolua_bin = 'tolua++5.1'
tolua_lib = 'tolua++5.1'
TOLUAPP = 'tolua++5.1'
EOF

cmake -DCMAKE_INSTALL_PREFIX=/usr .
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
