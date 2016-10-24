#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Sudo package allows a systembr3ak administrator to give certain users (or groups of users) thebr3ak ability to run some (or all) commands as <code class="systemitem">root or another user while logging the commandsbr3ak and arguments.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:linux-pam
#OPT:mitkrb
#OPT:openldap


#VER:sudo-.8.8p:1


NAME="sudo"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://www.sudo.ws/dist/sudo-1.8.18p1.tar.gz || wget -nc ftp://ftp.sudo.ws/pub/sudo/sudo-1.8.18p1.tar.gz


URL=http://www.sudo.ws/dist/sudo-1.8.18p1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.18p1 \
            --with-passprompt="[sudo] password for %p" &&
make "-j`nproc`" || make


make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0


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




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
