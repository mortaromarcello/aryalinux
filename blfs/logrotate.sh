#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The logrotate package allowsbr3ak automatic rotation, compression, removal, and mailing of log files.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:popt
#REC:fcron


#VER:logrotate:3.9.1


NAME="logrotate"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/logrotate/logrotate-3.9.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/logrotate/logrotate-3.9.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/logrotate/logrotate-3.9.1.tar.gz || wget -nc https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.9.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/logrotate/logrotate-3.9.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/logrotate/logrotate-3.9.1.tar.gz


URL=https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.9.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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
chmod -v 0644 /etc/logrotate.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -p /etc/logrotate.d

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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
chmod -v 0644 /etc/logrotate.d/sys.log

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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
chmod -v 0644 /etc/logrotate.d/example.log

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST