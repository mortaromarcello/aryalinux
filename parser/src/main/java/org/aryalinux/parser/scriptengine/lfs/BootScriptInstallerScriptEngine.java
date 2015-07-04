package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;

public class BootScriptInstallerScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("bootscripts.html")) {
				FileOutputStream fileOutputStream = new FileOutputStream(
						new File(outputDirectory + File.separator
								+ (LFSParser.mainScriptIndex++) + ".sh"));
				fileOutputStream.write(step.toDefaultString().getBytes());
				fileOutputStream.close();
			}
		}
	}

}
