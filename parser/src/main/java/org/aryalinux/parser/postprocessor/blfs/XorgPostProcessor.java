package org.aryalinux.parser.postprocessor.blfs;

import java.util.LinkedHashMap;
import java.util.LinkedHashSet;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.utils.Eliminator;
import org.aryalinux.parser.utils.LineExtractor;
import org.aryalinux.parser.utils.Util;

public class XorgPostProcessor implements BLFSCommandsPostProcessor {
	private static final String XORG_VARS = "export XORG_PREFIX=\"/usr\"\n"
			+ "export XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"";

	public void process(BLFSPackage pack) throws Exception {
		if (Util.unify(pack.getCommands()).contains("$XORG_PREFIX")
				|| Util.unify(pack.getCommands()).contains("$XORG_CONFIG")
				&& !pack.getName().equals("xorg7")) {
			pack.setCommands(Util.divide("\n" + XORG_VARS + "\n\n"
					+ Util.unify(pack.getCommands())));
		}
		if (pack.getName().equals("xorg7")) {
			String commands = Util.unify(pack.getCommands());
			commands = Util.reformat(commands);
			commands = LineExtractor
					.extract(
							commands,
							"export XORG_PREFIX=\"<em class=\"replaceable\"><code><PREFIX></em>\"",
							"echo \"$XORG_PREFIX/lib\" >> /etc/ld.so.conf");
			pack.setCommands(Util.divide(commands));

			LinkedHashMap<String, String> replaceables = new LinkedHashMap<String, String>();
			replaceables.put("<em class=\"replaceable\"><code><PREFIX></em>",
					"/usr");

			commands = Eliminator.eliminate(replaceables, commands);
			pack.setCommands(Util.divide(commands));
		}
		if (pack.getDependencies().contains("installing")) {
			LinkedHashSet<String> deps = new LinkedHashSet<String>();
			for (String str : pack.getDependencies()) {
				if (str.equals("installing")) {
					deps.add("xorg-xserver");
				} else {
					deps.add(str);
				}
			}
			//pack.setDependencies(deps);
		}
		if (pack.getDependencies().contains("xorg7#xorg-env")) {
			LinkedHashSet<String> deps = new LinkedHashSet<String>();
			for (String str : pack.getDependencies()) {
				if (str.startsWith("xorg7#")) {
					deps.add("xorg7");
				} else {
					deps.add(str);
				}
			}
			//pack.setDependencies(deps);
		}
		if (pack.getName().equals("xorg-server")) {
			pack.getDependencies().remove("nettle");
			pack.getDependencies().remove("libgcrypt");
		}
	}

}
