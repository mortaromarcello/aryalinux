#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The IcedTea-Sound package containsbr3ak the <a class="xref" href="pulseaudio.html" title="PulseAudio-9.0">PulseAudio-9.0</a> provider which was removed frombr3ak IcedTea itself from version 2.5.0 onwards. More providers may bebr3ak included in the future.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:openjdk
#REQ:java
#REQ:pulseaudio


#VER:icedtea-sound:1.0.1


NAME="icedtea-sound"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-sound-1.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-sound-1.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-sound-1.0.1.tar.xz || wget -nc http://icedtea.classpath.org/download/source/icedtea-sound-1.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icedtea/icedtea-sound-1.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-sound-1.0.1.tar.xz


URL=http://icedtea.classpath.org/download/source/icedtea-sound-1.0.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --with-jdk-home=${JAVA_HOME} --disable-docs &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
case $(uname -m) in
  i?86   ) ARCH=i386 ;;
  x86_64 ) ARCH=amd64 ;;
esac &&
install icedtea-sound.jar ${JAVA_HOME}/jre/lib/ext &&
install build/native/libicedtea-sound.so ${JAVA_HOME}/jre/lib/$ARCH &&
unset ARCH

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> ${JAVA_HOME}/jre/lib/sound.properties << "EOF"
# Begin PulseAudio provider additions:
javax.sound.sampled.Clip=org.classpath.icedtea.pulseaudio.PulseAudioClip
javax.sound.sampled.SourceDataLine=org.classpath.icedtea.pulseaudio.PulseAudioSourceDataLine
javax.sound.sampled.TargetDataLine=org.classpath.icedtea.pulseaudio.PulseAudioTargetDataLine
# End PulseAudio provider additions
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
