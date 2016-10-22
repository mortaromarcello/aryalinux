#!/bin/bash

set -e
set +h

USERNAME="$1"

alps selfupdate
alps updatescripts
su - $USERNAME -c "alps install-no-prompt profile nano openssl general_which wget cacerts python2 python3 ntfs-3g fuse lvm2 parted gptfdisk shadow"
alps install-no-prompt sudo
su - $USERNAME -c "alps install-no-prompt usbutils pciutils openssh gobject-introspection libxml2 desktop-file-utils shared-mime-info ccache"
alps clean
