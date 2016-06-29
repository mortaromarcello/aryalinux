#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mplayer-SVN-r:37561
#VER:Clearlooks:1.7

#REQ:yasm
#REC:gtk2
#REC:libvdpau
#OPT:cdparanoia
#OPT:libcdio
#OPT:libdvdread
#OPT:libdvdnav
#OPT:libdvdcss
#OPT:samba
#OPT:pulseaudio
#OPT:sdl
#OPT:aalib
#OPT:giflib
#OPT:libjpeg
#OPT:libmng
#OPT:libpng
#OPT:openjpeg
#OPT:faac
#OPT:faad2
#OPT:lame
#OPT:liba52
#OPT:libdv
#OPT:libmad
#OPT:libmpeg2
#OPT:libtheora
#OPT:libvpx
#OPT:lzo
#OPT:mpg123
#OPT:speex
#OPT:xvid
#OPT:x264
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:gnutls
#OPT:openssl
#OPT:opus
#OPT:unrar
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/other/mplayer-SVN-r37561.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/MPlayer/mplayer-SVN-r37561.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/MPlayer/mplayer-SVN-r37561.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/MPlayer/mplayer-SVN-r37561.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/MPlayer/mplayer-SVN-r37561.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/other/mplayer-SVN-r37561.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/MPlayer/mplayer-SVN-r37561.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc https://www.mplayerhq.hu/MPlayer/skins/Clearlooks-1.7.tar.bz2 || wget -nc ftp://ftp.mplayerhq.hu/MPlayer/skins/Clearlooks-1.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's:libsmbclient.h:samba-4.0/&:' configure stream/stream_smb.c &&
./configure --prefix=/usr            \
            --confdir=/etc/mplayer   \
            --enable-dynamic-plugins \
            --enable-menu            \
            --enable-gui             &&
make "-j`nproc`"


make doc



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install  &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
        /usr/share/pixmaps/mplayer.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/mplayer-SVN-r37561 &&
install -v -m644    DOCS/HTML/en/* \
                    /usr/share/doc/mplayer-SVN-r37561

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 etc/codecs.conf /etc/mplayer

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 etc/*.conf /etc/mplayer

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xvf  ../Clearlooks-1.7.tar.bz2 \
    -C    /usr/share/mplayer/skins &&
ln  -sfvn Clearlooks /usr/share/mplayer/skins/default

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mplayer=>`date`" | sudo tee -a $INSTALLED_LIST

