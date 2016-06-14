#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:icedtea-sound:1.0.1

#REQ:openjdk
#REQ:java
#REQ:pulseaudio


cd $SOURCE_DIR

URL=http://icedtea.classpath.org/download/source/icedtea-sound-1.0.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea-sound/icedtea-sound-1.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icedtea-sound/icedtea-sound-1.0.1.tar.xz || wget -nc http://icedtea.classpath.org/download/source/icedtea-sound-1.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icedtea-sound/icedtea-sound-1.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea-sound/icedtea-sound-1.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icedtea-sound/icedtea-sound-1.0.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "icedtea-sound=>`date`" | sudo tee -a $INSTALLED_LIST

