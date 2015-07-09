#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:x7lib
#DEP:linux-pam
#DEP:polkit


cd $SOURCE_DIR

TARBALL=ConsoleKit-0.4.6.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://anduin.linuxfromscratch.org/sources/BLFS/svn/c/ConsoleKit-0.4.6.tar.xz


tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-udev-acl    \
            --enable-pam-module  \
            --with-systemdsystemunitdir=no &&
make

cat > 1434309266626.sh << ENDOFFILE
make install
ENDOFFILE
chmod a+x 1434309266626.sh
sudo ./1434309266626.sh
sudo rm -rf 1434309266626.sh

cat > 1434309266626.sh << "ENDOFFILE"
cat >> /etc/pam.d/system-session << "EOF"
# Begin ConsoleKit addition

session optional pam_loginuid.so
session optional pam_ck_connector.so nox11

# End ConsoleKit addition
EOF
ENDOFFILE
chmod a+x 1434309266626.sh
sudo ./1434309266626.sh
sudo rm -rf 1434309266626.sh

cat > 1434309266626.sh << "ENDOFFILE"
cat > /usr/lib/ConsoleKit/run-session.d/pam-foreground-compat.ck << "EOF"
#!/bin/sh
TAGDIR=/var/run/console

[ -n "$CK_SESSION_USER_UID" ] || exit 1
[ "$CK_SESSION_IS_LOCAL" = "true" ] || exit 0

TAGFILE="$TAGDIR/`getent passwd $CK_SESSION_USER_UID | cut -f 1 -d:`"

if [ "$1" = "session_added" ]; then
    mkdir -p "$TAGDIR"
    echo "$CK_SESSION_ID" >> "$TAGFILE"
fi

if [ "$1" = "session_removed" ] && [ -e "$TAGFILE" ]; then
    sed -i "\%^$CK_SESSION_ID\$%d" "$TAGFILE"
    [ -s "$TAGFILE" ] || rm -f "$TAGFILE"
fi
EOF
chmod -v 755 /usr/lib/ConsoleKit/run-session.d/pam-foreground-compat.ck
ENDOFFILE
chmod a+x 1434309266626.sh
sudo ./1434309266626.sh
sudo rm -rf 1434309266626.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "consolekit=>`date`" | sudo tee -a $INSTALLED_LIST