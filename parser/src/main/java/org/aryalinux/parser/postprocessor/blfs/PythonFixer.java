package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.utils.Util;

public class PythonFixer implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) throws Exception {
		if (pack.getName().equals("python3")) {
			String commands = Util.unify(pack.getCommands());
			commands = commands.replace("python-3.4.2-docs-html.tar.bz2",
					"python-3.4.3-docs-html.tar.bz2");
			pack.setCommands(Util.divide(commands));
		}
		if (pack.getDependencies().contains("python2")
				&& pack.getDependencies().contains("python3")) {
			pack.getDependencies().remove("python3");
		}
	}

}
