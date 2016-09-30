#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:wireshark:2.0.5

#REQ:glib2
#REC:gtk3
#REC:libpcap
#REC:qt5
#OPT:gnutls
#OPT:libgcrypt
#OPT:libnl
#OPT:lua
#OPT:mitkrb
#OPT:openssl
#OPT:sbc
#OPT:gtk2


cd $SOURCE_DIR

URL=https://www.wireshark.org/download/src/all-versions/wireshark-2.0.5.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wireshark/wireshark-2.0.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wireshark/wireshark-2.0.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wireshark/wireshark-2.0.5.tar.bz2 || wget -nc https://www.wireshark.org/download/src/all-versions/wireshark-2.0.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireshark/wireshark-2.0.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireshark/wireshark-2.0.5.tar.bz2 || wget -nc ftp://ftp.uni-kl.de/pub/wireshark/src/wireshark-2.0.5.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/wireshark/wireshark-2.0.5-lua_5_3_1-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/wireshark-2.0.5-lua_5_3_1-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 62 wireshark

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../wireshark-2.0.5-lua_5_3_1-1.patch  &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/wireshark-2.0.5 &&
install -v -m644    README{,.linux} doc/README.* doc/*.{pod,txt} \
                    /usr/share/doc/wireshark-2.0.5 &&
pushd /usr/share/doc/wireshark-2.0.5 &&
   for FILENAME in ../../wireshark/*.html; do
      ln -s -v -f $FILENAME .
   done &&
popd
unset FILENAME

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 <em class="replaceable"><code><Downloaded_Files></em> \
                 /usr/share/doc/wireshark-2.0.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chown -v root:wireshark /usr/bin/{tshark,dumpcap} &&
chmod -v 6550 /usr/bin/{tshark,dumpcap}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser
sudo usermod -a -G wireshark `cat /tmp/currentuser`



cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "wireshark=>`date`" | sudo tee -a $INSTALLED_LIST

