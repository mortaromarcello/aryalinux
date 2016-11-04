#!/bin/bash

set -e
set +h

USERNAME="$1"
PACKAGE="$2"

echo "Installing $2..."
alps selfupdate
alps updatescripts
su - $USERNAME -c "PKG_BUILDER=$3 alps install-no-prompt $PACKAGE"
if ! grep "$PACKAGE" /etc/alps/installed-list &> /dev/null
then
	echo "Application installation incomplete ($PACKAGE). Aborting..."
	exit 1
fi
