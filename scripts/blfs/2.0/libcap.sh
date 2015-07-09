#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:linux-pam


cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.24.tar.xz
wget -nc ftp://ftp.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.24.tar.xz


TARBALL=libcap-2.24.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make -C pam_cap

cat > 1434987998747.sh << "ENDOFFILE"
install -v -m755 pam_cap/pam_cap.so /lib/security/pam_cap.so &&
install -v -m644 pam_cap/capability.conf /etc/security
ENDOFFILE
chmod a+x 1434987998747.sh
sudo ./1434987998747.sh
sudo rm -rf 1434987998747.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libcap=>`date`" | sudo tee -a $INSTALLED_LIST