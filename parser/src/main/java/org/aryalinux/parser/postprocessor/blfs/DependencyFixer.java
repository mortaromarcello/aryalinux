package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;

public class DependencyFixer implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) throws Exception {
		if (pack.getName().equals("wget")) {
			pack.getDependencies().remove("gnutls");
		}
	}

}
