#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtkmm2
#DEP:parted


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/gparted/gparted-0.21.0.tar.bz2


TARBALL=gparted-0.21.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-doc    \
            --disable-static &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh

cat > 1434987998829.sh << "ENDOFFILE"
cp -v  /usr/share/applications/gparted.desktop \
       /usr/share/applications/gparted.desktop.back &&

sed -i 's/Exec=/Exec=sudo -A /' \
       /usr/share/applications/gparted.desktop
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh

cat > 1434987998829.sh << "ENDOFFILE"
cp -v  /usr/share/applications/gparted.desktop \
       /usr/share/applications/gparted.desktop.back &&

sed -i 's:/usr/sbin/gparted:/usr/sbin/gparted_polkit:' \
       /usr/share/applications/gparted.desktop      &&

cat > /usr/sbin/gparted_polkit << "EOF" &&
#!/bin/sh

pkexec /usr/sbin/gparted $@
EOF

chmod -v 755 /usr/sbin/gparted_polkit

cat > /usr/share/polkit-1/actions/org.gnome.gparted.policy << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>

 <action id="org.freedesktop.policykit.pkexec.run-gparted">
 <description>Run GParted</description>
 <message>Authentication is required to run GParted</message>
 <defaults>
 <allow_any>no</allow_any>
 <allow_inactive>no</allow_inactive>
 <allow_active>auth_admin_keep</allow_active>
 </defaults>
 <annotate key="org.freedesktop.policykit.exec.path">/usr/sbin/gparted</annotate>
 <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
 </action>

</policyconfig>
EOF

chmod -v 644 /usr/share/polkit-1/actions/org.gnome.gparted.policy
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gparted=>`date`" | sudo tee -a $INSTALLED_LIST