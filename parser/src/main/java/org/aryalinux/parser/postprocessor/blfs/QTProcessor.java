package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class QTProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) {
		if (pack.getName().equals("qt4")) {
			String[] commands = Util.unify(pack.getCommands()).split("\n");
			String finalCommands = "";
			boolean capture = true;
			for (String command : commands) {
				if (command.trim().contains("export QT4LINK=/usr")) {
					capture = false;
					continue;
				}
				if (capture == false && command.trim().equals("unset file")) {
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
