#!/bin/sh
# A short alternative to makepkg (Version 0.3)
#
# Usage: Switch into the staging directory containing all the files to
# be packaged and issue:
#
#  mkpkg /tmp/package-name-version-arch-buildtag.tgz
#
# Note: All files and folders become root owned by default. To prevent
# this add "-n" as an option, after "mkpkg".
mkpkg() {
  if [ "$1" = "-n" ]; then
    TAROWNER=""
    shift 1
  else
    TAROWNER="--group 0 --owner 0"
  fi
  if find * -type l | grep -qm1 .; then
    mkdir -p install
    find * -type l -printf '( cd %h ; rm -rf %f )\n( cd %h ; ln -sf %l %f )\n' -delete > install/symlinks
    if [ -f "install/doinst.sh" ]; then
      printf '\n' | cat - install/doinst.sh >> install/symlinks
    fi
    mv install/symlinks install/doinst.sh
  fi
  case "$1" in
    *tbz) cmp=bzip2 ;;
    *tgz) cmp=gzip ;;
    *tlz) cmp=lzma ;;
    *txz) cmp=xz ;;
    *tbr) cmp="bro --quality ${BROTLI_QUALITY:-5}" ;; # Experimental support for Brotli compression
    *) echo "Unknown compression type" >&2 ; exit 1 ;;
  esac
  tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names $TAROWNER | $cmp > "$1"
  echo "Slackware package \"$1\" created."
}
mkpkg "$@"
