package org.aryalinux.parser.commons.lfs;

import java.util.List;

public abstract class ScriptEngine {
	private String outputDirectory;

	public abstract void generateScript(List<Step> steps, String outputDirectory)
			throws Exception;

	public String getOutputDirectory() {
		return outputDirectory;
	}

	public void setOutputDirectory(String outputDirectory) {
		this.outputDirectory = outputDirectory;
	}

}
