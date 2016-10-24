#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libao package contains abr3ak cross-platform audio library. This is useful to output audio on abr3ak wide variety of platforms. It currently supports WAV files, OSSbr3ak (Open Sound System), ESD (Enlighten Sound Daemon), ALSA (Advancedbr3ak Linux Sound Architecture), NAS (Network Audio system), aRTS (analogbr3ak Real-Time Synthesizer and PulseAudio (next generation GNOME sound architecture).br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:pulseaudio
#OPT:xorg-server


#VER:libao:1.2.0


NAME="libao"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz


URL=http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 README /usr/share/doc/libao-1.2.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
