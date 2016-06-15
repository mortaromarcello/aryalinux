#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:wxpython:3.0.2

#REQ:wxwidgets

cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/wxPython/wxPython-src-3.0.2.0.tar.bz2/922b02ff2c0202a7bf1607c98bbbbc04/wxPython-src-3.0.2.0.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY
cd wxPython

export CC="gcc"
export CXX="g++"

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "wxpython=>`date`" | sudo tee -a $INSTALLED_LIST


