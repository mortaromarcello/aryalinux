package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.LineExtractor;

public class SystemdClockScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("clock.html")) {
				String commands = step.getCommands();
				commands = LineExtractor.extract(commands,
						"cat > /etc/adjtime << \"EOF\"", "EOF");
				step.setCommands(commands);
				FileOutputStream fileOutputStream = new FileOutputStream(
						new File(LFSParser.outputDirectory,
								(LFSParser.mainScriptIndex++) + ".sh"));
				fileOutputStream.write(step.toDefaultString().getBytes());
				fileOutputStream.close();
			}
		}
	}
}
