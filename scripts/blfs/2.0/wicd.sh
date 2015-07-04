#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2
#DEP:python-modules#dbus-python
#DEP:wireless_tools
#DEP:net-tools
#DEP:python-modules#pygtk
#DEP:wpa_supplicant
#DEP:dhcpcd


cd $SOURCE_DIR

wget -nc http://launchpad.net/wicd/1.7/1.7.3/+download/wicd-1.7.3.tar.gz


TARBALL=wicd-1.7.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e "/detection failed/ a\                self.init=\'init\/default\/wicd\'" \
    -i setup.py &&
rm po/*.po      &&
python setup.py configure --no-install-kde     \
                          --no-install-acpi    \
                          --no-install-pmutils \
                          --no-install-init    \
                          --docdir=/usr/share/doc/wicd-1.7.3

cat > 1434987998783.sh << "ENDOFFILE"
python setup.py install
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
systemctl enable wicd
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "wicd=>`date`" | sudo tee -a $INSTALLED_LIST