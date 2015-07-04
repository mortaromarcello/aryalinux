package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;

public class LogFileCreatorScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		InputStream inputStream = getClass().getClassLoader()
				.getResourceAsStream("log-file-creator-script-template");
		byte[] data = new byte[inputStream.available()];
		inputStream.read(data);
		inputStream.close();
		Step createfiles = null;
		for (Step step : steps) {
			if (step.getSource().equals("createfiles.html")) {
				createfiles = step;
			}
		}
		if (createfiles != null) {
			String createfilesCommands = createfiles.getCommands();
			String output = new String(data);
			StringBuilder commandsToBeAdded = new StringBuilder();
			String[] lines = createfilesCommands.split("\n");
			boolean startAdding = false;
			for (String line : lines) {
				if (startAdding) {
					commandsToBeAdded.append(line + "\n");
				}
				if (line.trim().equals("exec /tools/bin/bash --login +h")) {
					startAdding = true;
				}
			}
			output = output.replace("[_CREATE_LOGS_]",
					commandsToBeAdded.toString());
			FileOutputStream fileOutputStream = new FileOutputStream(new File(
					outputDirectory + File.separator
							+ (LFSParser.mainScriptIndex++) + ".sh"));
			fileOutputStream.write(output.getBytes());
			fileOutputStream.close();
		}
	}

}
