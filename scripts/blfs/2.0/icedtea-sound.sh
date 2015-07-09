#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openjdk
#DEP:java
#DEP:pulseaudio


cd $SOURCE_DIR

wget -nc http://icedtea.classpath.org/download/source/icedtea-sound-1.0.1.tar.xz


TARBALL=icedtea-sound-1.0.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --with-jdk-home=${JAVA_HOME} --disable-docs &&
make

cat > 1434987998834.sh << "ENDOFFILE"
case $(uname -m) in
  i?86   ) ARCH=i386 ;;
  x86_64 ) ARCH=amd64 ;;
esac &&

install icedtea-sound.jar ${JAVA_HOME}/jre/lib/ext &&
install build/native/libicedtea-sound.so ${JAVA_HOME}/jre/lib/$ARCH &&
unset ARCH
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh

cat > 1434987998834.sh << "ENDOFFILE"
cat >> ${JAVA_HOME}/jre/lib/sound.properties << "EOF"
# Begin PulseAudio provider additions:

javax.sound.sampled.Clip=org.classpath.icedtea.pulseaudio.PulseAudioClip
javax.sound.sampled.SourceDataLine=org.classpath.icedtea.pulseaudio.PulseAudioSourceDataLine
javax.sound.sampled.TargetDataLine=org.classpath.icedtea.pulseaudio.PulseAudioTargetDataLine

# End PulseAudio provider additions
EOF
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "icedtea-sound=>`date`" | sudo tee -a $INSTALLED_LIST