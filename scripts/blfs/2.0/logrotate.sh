#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:popt
#DEP:fcron


cd $SOURCE_DIR

wget -nc https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.8.9.tar.gz


TARBALL=logrotate-3.8.9.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./autogen.sh &&
./configure --prefix=/usr &&
make

cat > 1434987998771.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
cat > /etc/logrotate.conf << EOF
# Begin of /etc/logrotate.conf

# Rotate log files weekly
weekly

# Don't mail logs to anybody
nomail

# If the log file is empty, it will not be rotated
notifempty

# Number of backups that will be kept
# This will keep the 2 newest backups only
rotate 2

# Create new empty files after rotating old ones
# This will create empty log files, with owner
# set to root, group set to sys, and permissions 644
create 0664 root sys

# Compress the backups with gzip
compress

# No packages own lastlog or wtmp -- rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
    rotate 1
}

/var/log/lastlog {
    monthly
    rotate 1
}

# Some packages drop log rotation info in this directory
# so we include any file in it.
include /etc/logrotate.d

# End of /etc/logrotate.conf
EOF

chmod -v 644 /etc/logrotate.conf
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
mkdir -p /etc/logrotate.d
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
cat > /etc/logrotate.d/sys.log << EOF
/var/log/sys.log {
   # If the log file is larger than 100kb, rotate it
   size   100k
   rotate 5
   weekly
   postrotate
      /bin/killall -HUP syslogd
   endscript
}
EOF

chmod -v 644 /etc/logrotate.d/sys.log
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
cat > /etc/logrotate.d/example.log << EOF
file1
file2
file3 {
   ...
   postrotate
    ...
   endscript
}
EOF

chmod -v 644 /etc/logrotate.d/example.log
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "logrotate=>`date`" | sudo tee -a $INSTALLED_LIST