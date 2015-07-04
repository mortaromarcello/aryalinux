#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2


cd $SOURCE_DIR

wget -nc http://mercurial.selenic.com/release/mercurial-3.3.tar.gz


TARBALL=mercurial-3.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make build

make doc

cat > tests/blacklists/failed-tests << "EOF"
# Test Failures
 test-parse-date.t
EOF
rm -rf tests/tmp &&
TESTFLAGS="-j<em class="replaceable"><code><N></em> --tmpdir tmp --blacklist blacklists/failed-tests" \
make check

pushd tests &&
rm -rf tmp  &&
./run-tests.py --debug --tmpdir tmp test-parse-date.t &&
popd

cat > 1434987998776.sh << "ENDOFFILE"
make PREFIX=/usr install-bin
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
make PREFIX=/usr install-doc
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat >> ~/.hgrc << "EOF"
[ui]
username = <user_name> <your@mail>
EOF

cat > 1434987998776.sh << "ENDOFFILE"
install -v -d -m755 /etc/mercurial &&
cat > /etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/ssl/ca-bundle.crt
EOF
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mercurial=>`date`" | sudo tee -a $INSTALLED_LIST