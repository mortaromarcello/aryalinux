package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class DBusRemoveTestsProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) {
		if (pack.getName().equals("dbus")) {
			String cmds = Util.unify(pack.getCommands());
			String[] commands = cmds.split("\n");
			String finalCommands = "";
			boolean capture = true;
			for (String command : commands) {
				if (command.trim().startsWith("make distclean")) {
					capture = false;
					continue;
				}
				if (capture == false
						&& command.endsWith("test/name-test/Makefile.in")) {
					capture = true;
					continue;
				}
				if (capture) {
					finalCommands = finalCommands + command + "\n";
				}
			}
			pack.getCommands().clear();
			pack.getCommands().add(new UserCommand(finalCommands, "root"));
		}
	}

}
