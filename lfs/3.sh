#!/bin/bash

set -e
set +h

. /sources/build-properties

touch /var/log/{btmp,lastlog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

for SCRIPT in final-system/*.sh
do
	$SCRIPT
done

echo "Enter exit twice to proceed."
echo "You need to type exit and press enter and once again type exit and press enter."
