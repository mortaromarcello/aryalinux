package org.aryalinux.parser.ui.blfs;

import org.aryalinux.parser.commons.blfs.BLFSPackage;

public interface ScriptGenerator {
	public void setDestination(String destinationDirectory) throws Exception;

	public void setTemplate(String templatefile) throws Exception;

	public void generate(BLFSPackage blfsPackage) throws Exception;
}
