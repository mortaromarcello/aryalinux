#!/bin/bash
set -e
set +h

install -vdm755 /opt/lxqt/{bin,lib,share/man}
cat > /etc/profile.d/lxqt.sh << "EOF"
# Begin LXQt profile
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin PATH
pathappend /opt/lxqt/share/man/ MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/plugins QT_PLUGIN_PATH
# End LXQt profile
EOF
cat >> /etc/profile.d/qt5.sh << "EOF"

# Begin Qt5 changes for LXQt
pathappend $QT5DIR/plugins QT_PLUGIN_PATH
# End Qt5 changes for LXQt
EOF

cat >> /etc/ld.so.conf << "EOF"

# Begin LXQt addition
/opt/lxqt/lib
# End LXQt addition

EOF

