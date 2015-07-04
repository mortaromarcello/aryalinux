package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class MultithreadedMakeProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) {
		String commands = Util.unify(pack.getCommands());
		commands = commands.replace("\nmake\n", "\nmake \"-j`nproc`\"\n");
		pack.getCommands().clear();
		pack.getCommands().add(new UserCommand(commands, "root"));
	}

}
