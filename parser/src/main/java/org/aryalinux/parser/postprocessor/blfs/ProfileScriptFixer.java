package org.aryalinux.parser.postprocessor.blfs;

import java.util.StringTokenizer;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class ProfileScriptFixer implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) throws Exception {
		if (pack.getName().equals("profile")) {
			String commands = Util.unify(pack.getCommands());
			StringTokenizer st = new StringTokenizer(commands, "\n", true);
			String newCommands = "";
			while (st.hasMoreTokens()) {
				String str = st.nextToken();
				if (str.startsWith("export LANG=")) {
					newCommands += "export LANG=en_IN.utf-8\n";
				} else {
					newCommands += str;
				}
			}
			pack.getCommands().clear();
			pack.getCommands().add(new UserCommand(newCommands, "root"));
		}
	}

}
