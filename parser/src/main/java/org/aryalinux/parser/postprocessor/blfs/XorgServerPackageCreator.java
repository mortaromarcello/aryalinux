package org.aryalinux.parser.postprocessor.blfs;

import java.util.LinkedHashSet;

import org.aryalinux.parser.blfs.MetaPackageBuilder;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;

public class XorgServerPackageCreator implements MetaPackageBuilder {

	public BLFSPackage createPackage() {
		BLFSPackage pack = new BLFSPackage();
		pack.setName("xorg-xserver");
		LinkedHashSet<String> deps = new LinkedHashSet<String>();
		deps.add("xorg7");
		deps.add("util-macros");
		deps.add("x7proto");
		deps.add("libXau");
		deps.add("libXdmcp");
		deps.add("xcb-proto");
		deps.add("libxcb");
		deps.add("xcb-util");
		deps.add("xcb-util-image");
		deps.add("xcb-util-keysyms");
		deps.add("xcb-util-renderutil");
		deps.add("xcb-util-wm");
		deps.add("mesalib");
		deps.add("xbitmaps");
		deps.add("x7app");
		deps.add("xcursor-themes");
		deps.add("x7font");
		deps.add("xkeyboard-config");
		deps.add("xorg-server");
		deps.add("x7driver#libevdev");
		deps.add("x7driver#libva");
		deps.add("x7driver#libvdpau");
		deps.add("x7driver#xorg-ati-driver");
		deps.add("x7driver#xorg-evdev-driver");
		deps.add("x7driver#xorg-fbdev-driver");
		deps.add("x7driver#xorg-intel-driver");
		deps.add("x7driver#xorg-nouveau-driver");
		deps.add("x7driver#xorg-synaptics-driver");
		deps.add("x7driver#xorg-vmmouse-driver");
		deps.add("x7driver#xorg-vmware-driver");
		deps.add("x7driver#xorg-wacom-driver");
		deps.add("twm");
		deps.add("xterm");
		deps.add("xclock");
		deps.add("xinit");
		//pack.setDependencies(deps);
		pack.getCommands().add(new UserCommand("echo \"Installing XServer.\"", "root"));
		return pack;
	}

}
