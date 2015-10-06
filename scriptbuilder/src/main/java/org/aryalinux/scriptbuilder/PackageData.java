package org.aryalinux.scriptbuilder;

public class PackageData {
	private String name;
	private String sourceUrl;
	private String additionalUrls;
	private String commands;

	public PackageData(String sourceUrl, String additionalUrls, String commands) {
		this.sourceUrl = sourceUrl;
		this.additionalUrls = additionalUrls;
		this.commands = commands;
	}

	public String getSourceUrl() {
		return sourceUrl;
	}

	public void setSourceUrl(String sourceUrl) {
		this.sourceUrl = sourceUrl;
	}

	public String getAdditionalUrls() {
		return additionalUrls;
	}

	public void setAdditionalUrls(String additionalUrls) {
		this.additionalUrls = additionalUrls;
	}

	public String getCommands() {
		return commands;
	}

	public void setCommands(String commands) {
		this.commands = commands;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
