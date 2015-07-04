package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class TestsDisablingProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) {
		String commands = Util.unify(pack.getCommands());
		if (commands != null && (commands.contains("make check")
				|| commands.contains("make test"))) {
			commands = commands.replace("make check", "");
			commands = commands.replace("make test", "");

			pack.getCommands().clear();
			pack.getCommands().add(new UserCommand(commands, "root"));
		}
	}
}
