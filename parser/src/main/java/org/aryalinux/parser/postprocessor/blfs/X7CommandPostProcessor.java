package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class X7CommandPostProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) {
		if (pack.getName().contains("x7proto")
				|| pack.getName().contains("x7app")
				|| pack.getName().contains("x7lib")
				|| pack.getName().contains("x7font")) {
			String commands = Util.unify(pack.getCommands());
			commands = commands.replace("\nbash -e", "\n");
			commands = commands.replace("\nexit", "\n");
			commands = commands.replace("wget -i- -c", "wget -i- -nc");
			commands = commands.replace("\nmkdir", "\nmkdir -pv");
			commands = commands.replace("grep -A9 summary *make_check.log", "");
			commands = commands
					.replace(
							"\nln -sv $XORG_PREFIX/lib/X11 /usr/lib/X11 &&\nln -sv $XORG_PREFIX/include/X11 /usr/include/X11",
							"\n");

			pack.getCommands().clear();
			pack.getCommands().add(new UserCommand(commands, "root"));

		}
	}

}
