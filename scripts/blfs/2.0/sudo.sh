#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.sudo.ws/sudo/dist/sudo-1.8.12.tar.gz
wget -nc ftp://ftp.sudo.ws/pub/sudo/sudo-1.8.12.tar.gz


TARBALL=sudo-1.8.12.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.12 \
            --with-passprompt="[sudo] password for %p " &&
make

cat > 1434987998750.sh << "ENDOFFILE"
make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth include system-auth

# include the default account settings
account include system-account

# Set default environment variables for the service user
session required pam_env.so

# include system session defaults
session include system-session

# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sudo=>`date`" | sudo tee -a $INSTALLED_LIST