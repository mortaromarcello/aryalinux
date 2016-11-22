#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME=mate-desktop-environment
DESCRIPTION="The classic linux desktop environment forked from the gnome 2 desktop environment."
VERSION=1.16

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info
#REQ:libxml2
#REQ:libxslt
#REQ:glib2
#REQ:libidl
#REQ:dbus
#REQ:dbus-glib
#REQ:polkit
#REQ:popt
#REQ:libgcrypt
#REQ:gtk2
#REQ:libcanberra
#REQ:libart
#REQ:libglade
#REQ:libtasn1
#REQ:libxklavier
#REQ:libsoup
#REQ:icon-naming-utils
#REQ:libunique
#REQ:libunique3
#REQ:libwnck
#REQ:librsvg
#REQ:upower
#REQ:intltool
#REQ:libtasn1
#REQ:libtool
#REQ:xmlto
#REQ:gtk-doc
#REQ:rarian
#REQ:dconf
#REQ:libsecret
#REQ:gnome-keyring
#REQ:libnotify
#REQ:libwnck2
#REQ:zenity
#REC:yelp
#REQ:xdg-utils
#REQ:xdg-user-dirs

#REQ:mate-common
#REQ:mate-desktop
#REQ:libmatekbd
#REQ:libmatewnck
#REQ:libmateweather
#REQ:mate-icon-theme
#REQ:caja
#REQ:marco
#REQ:mate-settings-daemon
#REQ:mate-session-manager
#REQ:mate-menus
#REQ:mate-panel
#REQ:mate-control-center
#REQ:lightdm
#REQ:lightdm-gtk-greeter
#REQ:plymouth
#REQ:mate-screensaver

#REQ:mate-terminal
#REQ:caja
#REQ:caja-extensions
#REQ:caja-dropbox
#REQ:pluma
#REQ:galculator
#REQ:gpicview
#REQ:engrampa
#REQ:atril
#REQ:mate-utils
#REQ:murrine-gtk-engine
#REQ:mate-themes-gtk3
#REQ:gnome-themes-standard
#REQ:adwaita-icon-theme
#REQ:mate-system-monitor
#REQ:mate-power-manager
#REQ:marco
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REQ:mozo
#REQ:mate-backgrounds
#REQ:mate-media

#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:ModemManager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb_modeswitch
#REQ:compton

sudo tee /etc/gtk-2.0/gtkrc <<"EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF

sudo mkdir -pv /etc/polkit-1/localauthority/50-local.d/
sudo mkdir -pv /etc/polkit-1/rules.d/

sudo tee /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManagerAndUdisks2.rules <<"EOF"
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 || action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0) {
    return polkit.Result.YES;
  }
});
EOF

sudo mkdir -pv /usr/share/icons/default/
sudo tee /usr/share/icons/default/index.theme <<"EOF"
[Icon Theme]
Inherits=Adwaita
EOF

ccache -C
sudo ccache -C
ccache -c
sudo ccache -c

rm -rf ~/.ccache
sudo rm -rf ~/.ccache
xdg-user-dirs-update
sudo xdg-user-dirs-update

sudo tee /etc/profile.d/xdg.sh << EOF
cd ~
xdg-user-dirs-update
EOF

sudo rm -rf /etc/X11/xorg.conf.d/*

sudo tee /etc/X11/xorg.conf.d/99-synaptics-overrides.conf <<"EOF"
Section  "InputClass"
    Identifier  "touchpad overrides"
    # This makes this snippet apply to any device with the "synaptics" driver
    # assigned
    MatchDriver  "synaptics"

    ####################################
    ## The lines that you need to add ##
    # Enable left mouse button by tapping
    Option  "TapButton1"  "1"
    # Enable vertical scrolling
    Option  "VertEdgeScroll"  "1"
    # Enable right mouse button by tapping lower right corner
    Option "RBCornerButton" "3"
    ####################################

EndSection
EOF

if [ ! -f /usr/share/pixmaps/aryalinux.org ]
then
pushd /usr/share/pixmaps/
sudo wget aryalinux.org/releases/2016.04/aryalinux.png
popd
fi

sudo sed -i "s@/share/backgrounds/mate/desktop/Stripes.png@/share/backgrounds/aryalinux/2016_05_Life-of-Pix-free-peaceful-Lake-mountains-OlivierMiche.jpg@g" /usr/share/glib-2.0/schemas/org.mate.background.gschema.xml
sudo sed -i "s@'Sans 10'@'Noto Sans 10'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Sans 8'@'Noto Sans 8'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Sans 11'@'Noto Sans 11'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Sans Bold 10'@'Noto Sans 10'@g" /usr/share/glib-2.0/schemas/*.xml

sudo sed -i "s@'Monospace 10'@'Droid Sans Mono 10'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Monospace 11'@'Droid Sans Mono 12'@g" /usr/share/glib-2.0/schemas/*.xml

sudo sed -i "s@'Menta'@'Arc-Dark'@g" /usr/share/glib-2.0/schemas/org.mate.marco.gschema.xml
sudo sed -i "s@'Menta'@'Arc'@g" /usr/share/glib-2.0/schemas/org.mate.interface.gschema.xml
sudo sed -i "s@'menta'@'Numix-Circle'@g" /usr/share/glib-2.0/schemas/org.mate.interface.gschema.xml

sudo sed -i "0,/<default>false<\/default>/{s/<default>false<\/default>/<default>true<\/default>/}" /usr/share/glib-2.0/schemas/org.gnome.desktop.peripherals.gschema.xml
sudo sed -i "0,/<default>false<\/default>/{s/<default>false<\/default>/<default>true<\/default>/}" /usr/share/glib-2.0/schemas/org.mate.peripherals-touchpad.gschema.xml
sudo sed -i "0,/<default>false<\/default>/{s/<default>false<\/default>/<default>true<\/default>/}" /usr/share/glib-2.0/schemas/org.mate.peripherals-touchpad.gschema.xml
sudo sed -i "0,/<default>true<\/default>/{s/<default>true<\/default>/<default>false<\/default>/}" /usr/share/glib-2.0/schemas/org.mate.peripherals-touchpad.gschema.xml

cd /usr/share/glib-2.0/schemas/

cat > org.mate.peripherals-touchpad.gschema.xml <<"EOF"
<schemalist gettext-domain="mate-screensaver">
  <enum id="org.mate.screensaver.Mode">
    <value nick="blank-only" value="0"/>
    <value nick="random" value="1"/>
    <value nick="single" value="2"/>
  </enum>
  <schema id="org.mate.screensaver" path="/org/mate/screensaver/">
    <key name="idle-activation-enabled" type="b">
      <default>true</default>
      <summary>Activate when idle</summary>
      <description>Set this to TRUE to activate the screensaver when the session is idle.</description>
    </key>
    <key name="lock-enabled" type="b">
      <default>true</default>
      <summary>Lock on activation</summary>
      <description>Set this to TRUE to lock the screen when the screensaver goes active.</description>
    </key>
    <key name="mode" enum="org.mate.screensaver.Mode">
      <default>'blank-only'</default>
      <summary>Screensaver theme selection mode</summary>
      <description>The selection mode used by screensaver. May be "blank-only" to enable the screensaver without using any theme on activation, "single" to enable screensaver using only one theme on activation (specified in "themes" key), and "random" to enable the screensaver using a random theme on activation.</description>
    </key>
    <key name="themes" type="as">
      <default>[]</default>
      <summary>Screensaver themes</summary>
      <description>This key specifies the list of themes to be used by the screensaver. It's ignored when "mode" key is "blank-only", should provide the theme name when "mode" is "single", and should provide a list of themes when "mode" is "random".</description>
    </key>
    <key name="power-management-delay" type="i">
      <default>30</default>
      <summary>Time before power management baseline</summary>
      <description>The number of seconds of inactivity before signalling to power management. This key is set and maintained by the session power management agent.</description>
    </key>
      <key name="cycle-delay" type="i">
      <default>10</default>
      <summary>Time before theme change</summary>
      <description>The number of minutes to run before changing the screensaver theme.</description>
    </key>
    <key name="lock-delay" type="i">
      <default>0</default>
      <summary>Time before locking</summary>
      <description>The number of minutes after screensaver activation before locking the screen.</description>
    </key>
    <key name="embedded-keyboard-enabled" type="b">
      <default>false</default>
      <summary>Allow embedding a keyboard into the window</summary>
      <description>Set this to TRUE to allow embedding a keyboard into the window when trying to unlock. The "keyboard_command" key must be set with the appropriate command.</description>
    </key>
    <key name="embedded-keyboard-command" type="s">
      <default>''</default>
      <summary>Embedded keyboard command</summary>
      <description>The command that will be run, if the "embedded_keyboard_enabled" key is set to TRUE, to embed a keyboard widget into the window. This command should implement an XEMBED plug interface and output a window XID on the standard output.</description>
    </key>
    <key name="logout-enabled" type="b">
      <default>false</default>
      <summary>Allow logout</summary>
      <description>Set this to TRUE to offer an option in the unlock dialog to allow logging out after a delay. The delay is specified in the "logout_delay" key.</description>
    </key>
    <key name="logout-delay" type="i">
      <default>120</default>
      <summary>Time before logout option</summary>
      <description>The number of minutes after the screensaver activation before a logout option will appear in the unlock dialog. This key has effect only if the "logout_enable" key is set to TRUE.</description>
    </key>
    <key name="logout-command" type="s">
      <default>''</default>
      <summary>Logout command</summary>
      <description>The command to invoke when the logout button is clicked. This command should simply log the user out without any interaction. This key has effect only if the "logout_enable" key is set to TRUE.</description>
    </key>
    <key name="user-switch-enabled" type="b">
      <default>true</default>
      <summary>Allow user switching</summary>
      <description>Set this to TRUE to offer an option in the unlock dialog to switch to a different user account.</description>
    </key>
    <key name="lock-dialog-theme" type="s">
      <default>'default'</default>
      <summary>Theme for lock dialog</summary>
      <description>Theme to use for the lock dialog</description>
    </key>
    <key name="status-message-enabled" type="b">
      <default>true</default>
      <summary>Allow the session status message to be displayed</summary>
      <description>Allow the session status message to be displayed when the screen is locked.</description>
    </key>
  </schema>
</schemalist>
<schemalist gettext-domain="mate-settings-daemon">
  <schema id="org.mate.peripherals-touchpad" path="/org/mate/desktop/peripherals/touchpad/">
    <key name="disable-while-typing" type="b">
      <default>false</default>
      <summary>Disable touchpad while typing</summary>
      <description>Set this to TRUE if you have problems with accidentally hitting the touchpad while typing.</description>
    </key>
    <key name="tap-to-click" type="b">
      <default>true</default>
      <summary>Enable mouse clicks with touchpad</summary>
      <description>Set this to TRUE to be able to send mouse clicks by tapping on the touchpad.</description>
    </key>
    <key name="scroll-method" type="i">
      <default>1</default>
      <summary>Select the touchpad scroll method</summary>
      <description>Select the touchpad scroll method. Supported values are: 0: disabled, 1: edge scrolling, and 2: two-finger scrolling</description>
    </key>
    <key name="horiz-scroll-enabled" type="b">
      <default>false</default>
      <summary>Enable horizontal scrolling</summary>
      <description>Set this to TRUE to allow horizontal scrolling by the same method selected with the scroll_method key.</description>
    </key>
    <key name="natural-scroll" type="b">
      <default>false</default>
      <summary>Natural scrolling</summary>
      <description>Set this to true to enable natural (reverse) scrolling for touchpads</description>
    </key>
    <key name="touchpad-enabled" type="b">
      <default>true</default>
      <summary>Enable touchpad</summary>
      <description>Set this to TRUE to enable all touchpads.</description>
    </key>
    <key name="two-finger-click" type="i">
      <default>3</default>
      <summary>Enabled two-finger button-click emulation</summary>
      <description>0 thru 3, 0 is inactive, 1-3 is button to emulate</description>
    </key>
    <key name="three-finger-click" type="i">
      <default>2</default>
      <summary>Enable three-finger button-click emulation</summary>
      <description>0 thru 3, 0 is inactive, 1-3 is button to emulate</description>
    </key>
    <key name="tap-button-one-finger" type="i">
      <default>1</default>
      <summary>One finger tap button</summary>
      <description>Select the button mapping for one-finger tap. Supported values are: 1: left mouse button 2: middle mouse button 3: right mouse button</description>
    </key>
        <key name="tap-button-two-finger" type="i">
      <default>3</default>
      <summary>Two finger tap button</summary>
      <description>Select the button mapping for two-finger tap. Supported values are: 1: left mouse button 2: middle mouse button 3: right mouse button</description>
    </key>
    <key name="tap-button-three-finger" type="i">
      <default>2</default>
      <summary>Three finger tap button</summary>
      <description>Select the button mapping for three-finger tap. Supported values are: 1: left mouse button 2: middle mouse button 3: right mouse button</description>
    </key>
  </schema>
</schemalist>
EOF

cat > org.mate.screensaver.gschema.xml <<"EOF"
<schemalist gettext-domain="mate-screensaver">
  <enum id="org.mate.screensaver.Mode">
    <value nick="blank-only" value="0"/>
    <value nick="random" value="1"/>
    <value nick="single" value="2"/>
  </enum>
  <schema id="org.mate.screensaver" path="/org/mate/screensaver/">
    <key name="idle-activation-enabled" type="b">
      <default>true</default>
      <summary>Activate when idle</summary>
      <description>Set this to TRUE to activate the screensaver when the session is idle.</description>
    </key>
    <key name="lock-enabled" type="b">
      <default>false</default>
      <summary>Lock on activation</summary>
      <description>Set this to TRUE to lock the screen when the screensaver goes active.</description>
    </key>
    <key name="mode" enum="org.mate.screensaver.Mode">
      <default>'blank-only'</default>
      <summary>Screensaver theme selection mode</summary>
      <description>The selection mode used by screensaver. May be "blank-only" to enable the screensaver without using any theme on activation, "single" to enable screensaver using only one theme on activation (specified in "themes" key), and "random" to enable the screensaver using a random theme on activation.</description>
    </key>
    <key name="themes" type="as">
      <default>[]</default>
      <summary>Screensaver themes</summary>
      <description>This key specifies the list of themes to be used by the screensaver. It's ignored when "mode" key is "blank-only", should provide the theme name when "mode" is "single", and should provide a list of themes when "mode" is "random".</description>
    </key>
    <key name="power-management-delay" type="i">
      <default>30</default>
      <summary>Time before power management baseline</summary>
      <description>The number of seconds of inactivity before signalling to power management. This key is set and maintained by the session power management agent.</description>
    </key>
      <key name="cycle-delay" type="i">
      <default>10</default>
      <summary>Time before theme change</summary>
      <description>The number of minutes to run before changing the screensaver theme.</description>
    </key>
    <key name="lock-delay" type="i">
      <default>0</default>
      <summary>Time before locking</summary>
      <description>The number of minutes after screensaver activation before locking the screen.</description>
    </key>
    <key name="embedded-keyboard-enabled" type="b">
      <default>false</default>
      <summary>Allow embedding a keyboard into the window</summary>
      <description>Set this to TRUE to allow embedding a keyboard into the window when trying to unlock. The "keyboard_command" key must be set with the appropriate command.</description>
    </key>
    <key name="embedded-keyboard-command" type="s">
      <default>''</default>
      <summary>Embedded keyboard command</summary>
      <description>The command that will be run, if the "embedded_keyboard_enabled" key is set to TRUE, to embed a keyboard widget into the window. This command should implement an XEMBED plug interface and output a window XID on the standard output.</description>
    </key>
    <key name="logout-enabled" type="b">
      <default>false</default>
      <summary>Allow logout</summary>
      <description>Set this to TRUE to offer an option in the unlock dialog to allow logging out after a delay. The delay is specified in the "logout_delay" key.</description>
    </key>
    <key name="logout-delay" type="i">
      <default>120</default>
      <summary>Time before logout option</summary>
      <description>The number of minutes after the screensaver activation before a logout option will appear in the unlock dialog. This key has effect only if the "logout_enable" key is set to TRUE.</description>
    </key>
    <key name="logout-command" type="s">
      <default>''</default>
      <summary>Logout command</summary>
      <description>The command to invoke when the logout button is clicked. This command should simply log the user out without any interaction. This key has effect only if the "logout_enable" key is set to TRUE.</description>
    </key>
    <key name="user-switch-enabled" type="b">
      <default>true</default>
      <summary>Allow user switching</summary>
      <description>Set this to TRUE to offer an option in the unlock dialog to switch to a different user account.</description>
    </key>
    <key name="lock-dialog-theme" type="s">
      <default>'default'</default>
      <summary>Theme for lock dialog</summary>
      <description>Theme to use for the lock dialog</description>
    </key>
    <key name="status-message-enabled" type="b">
      <default>true</default>
      <summary>Allow the session status message to be displayed</summary>
      <description>Allow the session status message to be displayed when the screen is locked.</description>
    </key>
  </schema>
</schemalist>
EOF

glib-compile-schemas .

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
