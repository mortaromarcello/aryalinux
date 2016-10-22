#!/bin/bash

set -e
set +h

USERNAME="$1"
PACKAGE="$2"

echo "Installing $2..."
alps selfupdate
alps updatescripts
su - $USERNAME -c "alps install-no-prompt $PACKAGE"
alps clean
