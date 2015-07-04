package org.aryalinux.parser.commons.lfs;

import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Util;

public class Step {
	private Integer type;
	private String tarball;
	private String commands;
	private String directory;
	private String index;
	private String stepName;
	private String scriptName;
	private String source;

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getTarball() {
		return tarball;
	}

	public void setTarball(String tarball) {
		this.tarball = tarball;
	}

	public String getCommands() {
		return commands;
	}

	public void setCommands(String commands) {
		this.commands = commands;
	}

	public String getDirectory() {
		return directory;
	}

	public void setDirectory(String directory) {
		this.directory = directory;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		String[] parts = index.split("\\.");
		int second = Integer.parseInt(parts[1]);
		if (second < 10) {
			parts[1] = "0" + second;
		}
		this.index = parts[0] + "." + parts[1];
	}

	public String getStepName() {
		return stepName;
	}

	public void setStepName(String stepName) {
		this.stepName = stepName;
	}

	public String getScriptName() {
		return scriptName;
	}

	public void setScriptName(String scriptName) {
		this.scriptName = scriptName;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String toString() {
		String output = "";
		try {
			output = Util.readFileSimple(LFSParser.template);
			output = output.replace("_SOURCE_PATH_", LFSParser.sourcePath);
			output = output.replace("_LOG_PATH_", LFSParser.logPath);
			if (tarball != null) {
				output = output.replace("_TARBALL_", tarball);
				output = output.replace("_DIRECTORY_", directory);
			}
			output = output.replace("_COMMANDS_", Util.reformat(commands));
			output = output.replace("_STEP_NAME_", stepName);
			output = output.replace("_SCRIPT_NAME_", scriptName);
			output = output.replace("_INDEX_", index);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return output;
	}

	public String toDefaultString() {
		String output = "#!/bin/bash\n" + "\n" + "set -e\n" + "set +h\n" + "\n"
				+ "export SOURCE_DIR=\"_SOURCE_PATH_\"\n"
				+ "export LOG_PATH=\"_LOG_PATH_\"\n" + "\n"
				+ "export STEP_NAME=\"_STEP_NAME_\"\n";
		if (tarball != null) {
			output = output + "export TARBALL=\"_TARBALL_\"\n"
					+ "export DIRECTORY=\"_DIRECTORY_\"\n";
		}
		output = output + "\n" + "touch $LOG_PATH\n" + "cd $SOURCE_DIR\n\n"
				+ "if ! grep \"$STEP_NAME\" $LOG_PATH\n" + "then\n\n";
		if (tarball != null) {
			output = output + "tar -xf $TARBALL\n" + "cd $DIRECTORY\n" + "\n";
		}
		output = output + "_COMMANDS_\n" + "cd $SOURCE_DIR\n";
		if (tarball != null) {
			output = output + "rm -rf $DIRECTORY\n" + "rm -rf gcc-build\n"
					+ "rm -rf binutils-build\n" + "rm -rf glibc-build\n\n";
		}
		output = output + "echo \"$STEP_NAME\" >> $LOG_PATH\n\n" + "fi\n";

		output = output.replace("_SOURCE_PATH_", LFSParser.sourcePath);
		output = output.replace("_LOG_PATH_", LFSParser.logPath);
		if (tarball != null) {
			output = output.replace("_TARBALL_", tarball);
			output = output.replace("_DIRECTORY_", directory);
		}
		output = output.replace("_COMMANDS_", Util.reformat(commands));
		output = output.replace("_STEP_NAME_", stepName);
		output = output.replace("_SCRIPT_NAME_", scriptName);
		output = output.replace("_INDEX_", index);
		return output;
	}
}
