package org.aryalinux.parser.commons.blfs;

import java.io.Serializable;

@SuppressWarnings("serial")
public class UserCommand implements Serializable, Cloneable {
	private String command;
	private String executedBy;
	private boolean isDocCommand;

	public UserCommand(String command, String executedBy) {
		this.executedBy = executedBy;
		this.command = command;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	public String getExecutedBy() {
		return executedBy;
	}

	public void setExecutedBy(String executedBy) {
		this.executedBy = executedBy;
	}

	public String toString() {
		return command;
	}

	public boolean isDocCommand() {
		return isDocCommand;
	}

	public void setDocCommand(boolean isDocCommand) {
		this.isDocCommand = isDocCommand;
	}

	public UserCommand clone() throws CloneNotSupportedException {
		return (UserCommand) super.clone();
	}
}
