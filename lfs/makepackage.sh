#!/usr/bin/env bash
#
#
if [ -z "$1" ]; then
    echo "You must specify the name of the package to create!" >&2
    helptext
    exit 1
fi

PACKAGE=$1
PWD=$(pwd)
DIR_BUILD=$PWD/buildpackage

# I have put all the code into a function so that others can easily copy
# and paste it into another script.
fmakepkg() {
    # Handle Slackware's makepkg options
    while [ 0 ]; do
        if [ "$1" = "-p" -o "$1" = "--prepend" ]; then
            # option ignored, links are always prepended
            shift 1
        elif [ "$1" = "--linkadd" -o "$1" = "-l" ]; then
            if [ "$2" = "n" ]; then
                echo "\"$1 $2\" ignored, links are always converted" >&2
            fi
            shift 2
        elif [ "$1" = "--chown" -o "$1" = "-c" ]; then
            # This option now also changes ownership of all files to root:root
            SETPERMS="$2"
            shift 2
        else
            break
        fi
    done

    # Change any symlinks into shell script code
    if find * -type l | grep -qm1 .; then
        mkdir -p install
        find * -type l -printf '( cd %h ; rm -rf %f )\n( cd %h ; ln -sf %l %f )\n' -delete > install/symlinks
        if [ -f "install/doinst.sh" ]; then
            printf '\n' | cat - install/doinst.sh >> install/symlinks
        fi
        mv install/symlinks install/doinst.sh
    fi

    # Reset permissions and ownership
    if [ "${SETPERMS:-y}" = "y" ]; then
        find . -type d -exec chmod 755 {} \;
        # Changing file ownership is an unofficial extension to makepkg
        TAROWNER="--group 0 --owner 0"
    else
        TAROWNER=""
    fi

    # Create package using tar 1.13 directory formatting
    case "$1" in
        *tbz) cmp=bzip2 ;;
        *tgz) cmp=gzip ;;
        *tlz) cmp=lzma ;;
        *txz) cmp=xz ;;
        *tbr) cmp="bro --quality ${BROTLI_QUALITY:-5}" ;; # Experimental support for Brotli compression
        *) echo "Unknown compression type" >&2 ; exit 1 ;;
    esac
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names $TAROWNER | $cmp > "$1"
    echo "Blfs package \"$1\" created."
}

mkdir $DIR_BUILD
# warning! solo con configure
make install DESTDIR=$DIR_BUILD
strip -s $DIR_BUILD/usr/lib/* $DIR_BUILD/usr/bin/*
gzip -9 $DIR_BUILD/usr/man/man?/*.?
cd $DIR_BUILD
find . -type f -name "*"|sed 's/^.//' > ../../$PACKAGE.files
fmakepkg ../../$PACKAGE.tgz
cd $PWD
rm -rvf $DIR_BUILD

