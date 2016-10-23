#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The CrackLib package contains abr3ak library used to enforce strong passwords by comparing user selectedbr3ak passwords to words in chosen word lists.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:python2


#VER:cracklib:2.9.6
#VER:cracklib-words:2.9.6


NAME="cracklib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz
wget -nc https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-words-2.9.6.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz


URL=https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/skipping/d' util/packer.c &&
./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/lib/cracklib/pw_dict &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                      &&
mv -v /usr/lib/libcrack.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libcrack.so) /usr/lib/libcrack.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 -D    ../cracklib-words-2.9.6.gz \
                         /usr/share/dict/cracklib-words.gz     &&
gunzip -v                /usr/share/dict/cracklib-words.gz     &&
ln -v -sf cracklib-words /usr/share/dict/words                 &&
echo $(hostname) >>      /usr/share/dict/cracklib-extra-words  &&
install -v -m755 -d      /lib/cracklib                         &&
create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


make test




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
