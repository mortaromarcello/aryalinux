#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:toluapp:svn

#REQ:lua
#REQ:cmake
#REQ:git

cd $SOURCE_DIR

git clone https://github.com/LuaDist/toluapp.git
cd toluapp

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
rm -rf toluapp

echo "toluapp=>`date`" | sudo tee -a $INSTALLED_LIST

