#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Wireshark package contains abr3ak network protocol analyzer, also known as a “<span class=\"quote\">sniffer”. This is useful for analyzing databr3ak captured “<span class=\"quote\">off the wire” frombr3ak a live network connection, or data read from a capture file.br3ak"
SECTION="basicnet"
VERSION=2.2.1
NAME="wireshark"

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

URL=https://www.wireshark.org/download/src/all-versions/wireshark-2.2.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wireshark/wireshark-2.2.1.tar.bz2 || wget -nc https://www.wireshark.org/download/src/all-versions/wireshark-2.2.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireshark/wireshark-2.2.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireshark/wireshark-2.2.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wireshark/wireshark-2.2.1.tar.bz2 || wget -nc ftp://ftp.uni-kl.de/pub/wireshark/src/wireshark-2.2.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wireshark/wireshark-2.2.1.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/wireshark/wireshark-2.2.1-lua_5_3_1-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wireshark-2.2.1-lua_5_3_1-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 62 wireshark

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../wireshark-2.2.1-lua_5_3_1-1.patch  &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/wireshark-2.2.1 &&
install -v -m644    README{,.linux} doc/README.* doc/*.{pod,txt} \
                    /usr/share/doc/wireshark-2.2.1 &&
pushd /usr/share/doc/wireshark-2.2.1 &&
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
                 /usr/share/doc/wireshark-2.2.1

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





if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
