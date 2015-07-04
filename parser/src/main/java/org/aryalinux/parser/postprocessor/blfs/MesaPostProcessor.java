package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;

public class MesaPostProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) throws Exception {
		if (pack.getName().equals("mesalib")) {
			pack.getDependencies().remove("faq#part3");
		}
	}

}
