#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libao package contains abr3ak cross-platform audio library. This is useful to output audio on abr3ak wide variety of platforms. It currently supports WAV files, OSSbr3ak (Open Sound System), ESD (Enlighten Sound Daemon), ALSA (Advancedbr3ak Linux Sound Architecture), NAS (Network Audio system), aRTS (analogbr3ak Real-Time Synthesizer and PulseAudio (next generation GNOME sound architecture).br3ak
#SECTION:multimedia

#OPT:installing
#OPT:alsa
#OPT:pulseaudio


#VER:libao:1.2.0


NAME="libao"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz


URL=http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 README /usr/share/doc/libao-1.2.0
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
