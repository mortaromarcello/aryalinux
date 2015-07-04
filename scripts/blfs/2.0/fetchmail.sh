#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl
#DEP:procmail


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
wget -nc ftp://ftp.at.gnucash.org/pub/infosys/mail/fetchmail/fetchmail-6.3.26.tar.xz


TARBALL=fetchmail-6.3.26.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make

cat > 1434987998785.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh

cat > ~/.fetchmailrc << "EOF"
set logfile /var/log/fetchmail.log
set no bouncemail
set postmaster root

poll SERVERNAME :
 user <em class="replaceable"><code><username></em> pass <em class="replaceable"><code><password></em>;
 mda "/usr/bin/procmail -f %F -d %T";
EOF

chmod -v 0600 ~/.fetchmailrc


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fetchmail=>`date`" | sudo tee -a $INSTALLED_LIST