#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib
#DEP:alsa-plugins
#DEP:alsa-utils
#DEP:gstreamer
#DEP:gst-plugins-base
#DEP:gst-plugins-good
#DEP:gst-plugins-bad
#DEP:gst-plugins-ugly
#DEP:gstreamer10
#DEP:gst10-plugins-base
#DEP:gst10-plugins-good
#DEP:gst10-plugins-bad
#DEP:gst10-plugins-ugly
#DEP:libsndfile
#DEP:pulseaudio
 
echo "audio-meta=>`date`" | sudo tee -a $INSTALLED_LIST
