package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Util;

public class SysvinitNetworkScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		String filePath = LFSParser.outputDirectory + File.separator
				+ (LFSParser.mainScriptIndex++) + ".sh";
		Util.writeFile(filePath,
				Util.readResource("sysvinit-network-script-template"));
	}

}
