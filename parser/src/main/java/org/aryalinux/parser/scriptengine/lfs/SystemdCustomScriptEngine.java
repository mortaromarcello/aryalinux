package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.LineExtractor;
import org.aryalinux.parser.utils.Util;

public class SystemdCustomScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("systemd-custom.html")) {
				String commands = step.getCommands();
				commands = LineExtractor.extract(commands,
						"mkdir -pv /etc/systemd/system/getty@tty1.service.d",
						"ln -sfv /dev/null /etc/systemd/system/tmp.mount");
				step.setCommands(commands);
				String filePath = LFSParser.outputDirectory + File.separator
						+ (LFSParser.mainScriptIndex++) + ".sh";
				Util.writeFile(filePath, step.toDefaultString());
			}
		}
	}

}
