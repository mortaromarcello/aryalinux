#!/tools/bin/bash

set -e
set +h

touch /var/log/{btmp,lastlog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

for script in /sources/final-system/*.sh
do
	$script
done

/sources/4.sh

exit
