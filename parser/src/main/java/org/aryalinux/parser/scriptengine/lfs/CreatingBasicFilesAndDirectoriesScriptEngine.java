package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;

public class CreatingBasicFilesAndDirectoriesScriptEngine extends ScriptEngine {
	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		InputStream inputStream = getClass().getClassLoader()
				.getResourceAsStream("creating-basic-files-and-directories-script-template");
		byte[] data = new byte[inputStream.available()];
		inputStream.read(data);
		inputStream.close();
		Step creatingdirs = null, createfiles = null;
		for (Step step : steps) {
			if (step.getSource().equals("creatingdirs.html")) {
				creatingdirs = step;
			} else if (step.getSource().equals("createfiles.html")) {
				createfiles = step;
			}
		}
		if (createfiles != null && creatingdirs != null) {
			String creatingdirsCommands = creatingdirs.getCommands();
			String createfilesCommands = createfiles.getCommands();
			String output = new String(data);
			output = output.replace("[_CREATING_DIRS_]", creatingdirsCommands);
			StringBuilder chrootCommandsToBeAdded = new StringBuilder();
			String[] lines = createfilesCommands.split("\n");
			for (String line : lines) {
				chrootCommandsToBeAdded.append(line + "\n");
				if (line.trim().equals("exec /tools/bin/bash --login +h")) {
					break;
				}
			}
			output = output.replace("[_CREATE_FILES_AND_ENTER_SHELL]",
					chrootCommandsToBeAdded.toString());
			FileOutputStream fileOutputStream = new FileOutputStream(new File(
					outputDirectory + File.separator
							+ (LFSParser.mainScriptIndex++) + ".sh"));
			fileOutputStream.write(output.getBytes());
			fileOutputStream.close();
		}
	}

}
