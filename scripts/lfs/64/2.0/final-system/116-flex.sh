#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=flex-2.5.39.tar.bz2

if ! grep 117-flex $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39

make "-j`nproc`"

make install

cat > /usr/bin/lex << "EOF"
#!/bin/sh
# Begin /usr/bin/lex

exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF
chmod -v 755 /usr/bin/lex

cd $SOURCE_DIR
rm -rf $DIR
echo 117-flex >> $LOG

fi
