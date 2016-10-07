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

echo "Scrivi extit due volte per procedere."
echo "Hai bisogno di scrivere exit e premere enter e ancora scrivi exit e premi enter."
