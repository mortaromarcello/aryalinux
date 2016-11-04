#!/bin/bash
set -e
set +h

function postinstall()
{

export JAVA_HOME=/opt/jdk
cat >> ${JAVA_HOME}/jre/lib/sound.properties << "EOF"
# Begin PulseAudio provider additions:
javax.sound.sampled.Clip=org.classpath.icedtea.pulseaudio.PulseAudioClip
javax.sound.sampled.SourceDataLine=org.classpath.icedtea.pulseaudio.PulseAudioSourceDataLine
javax.sound.sampled.TargetDataLine=org.classpath.icedtea.pulseaudio.PulseAudioTargetDataLine
# End PulseAudio provider additions
EOF

}


preinstall()
{
echo "#"
}


$1
