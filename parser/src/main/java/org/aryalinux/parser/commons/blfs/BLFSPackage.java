package org.aryalinux.parser.commons.blfs;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class BLFSPackage implements Cloneable, Serializable {
	private String name;
	private String tarball;
	private String directoryName;
	private List<String> dependencies;
	private List<String> downloadUrls;
	private List<UserCommand> commands;
	private List<String> optionalDeps;
	private boolean dependsOnDoxygen;

	public BLFSPackage() {
		dependencies = new ArrayList<String>();
		downloadUrls = new ArrayList<String>();
		commands = new ArrayList<UserCommand>();
		optionalDeps = new ArrayList<String>();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTarball() {
		return tarball;
	}

	public void setTarball(String tarball) {
		this.tarball = tarball;
	}

	public String getDirectoryName() {
		return directoryName;
	}

	public void setDirectoryName(String directoryName) {
		this.directoryName = directoryName;
	}

	public List<String> getDependencies() {
		return dependencies;
	}

	public void setDependencies(List<String> dependencies) {
		this.dependencies = dependencies;
	}

	public List<UserCommand> getCommands() {
		return commands;
	}

	public void setCommands(List<UserCommand> commands) {
		this.commands = commands;
	}

	public List<String> getDownloadUrls() {
		return downloadUrls;
	}

	public void setDownloadUrls(List<String> downloadUrls) {
		this.downloadUrls = downloadUrls;
	}

	public List<String> getOptionalDeps() {
		return optionalDeps;
	}

	public void setOptionalDeps(List<String> optionalDeps) {
		this.optionalDeps = optionalDeps;
	}

	
	public boolean isDependsOnDoxygen() {
		return dependsOnDoxygen;
	}

	public void setDependsOnDoxygen(boolean dependsOnDoxygen) {
		this.dependsOnDoxygen = dependsOnDoxygen;
	}

	/*public String toString() {
		String output = "#!/bin/bash\n\n";
		if (!dependsOnDoxygen) {
			output = output + "set -e\n";
		}
		output = output + "set +h\n\n"
				+ ". /etc/alps/alps.conf\n\n";
		output = output + "#NAME:" + name + "\n";
		output = output + "\n";
		for (String dep : dependencies) {
			output = output + "#DEP:" + dep + "\n";
		}
		output = output + "\n";
		output = output + "cd $SOURCE_DIR\n";
		if (tarball != null && !tarball.equals("")) {
			for (String url : downloadUrls) {
				output = output + "wget -nc " + url + "\n";
			}
			output = output + "\n";
			output = output + "TARBALL=\"_TARBALL_\"\n";
			output = output + "SRC_DIR=\"_SRC_DIR_\"\n";
			output = output + "\n";
			output = output + "cd $SOURCE_DIR\n";
			output = output + "tar -xf $TARBALL\n";
			output = output + "cd $SRC_DIR\n";
		}
		output = output + "\n";
		for (UserCommand command : commands) {
			output = output + command.getCommand() + "\n";
		}
		output = output + "\n";
		output = output + "cd $SOURCE_DIR\n";
		if (tarball != null && !tarball.equals("")) {
			output = output + "rm -rf $SRC_DIR\n";
		}
		output = output + "\necho \"" + name + "=>`date`\" >> $INSTALLED_LIST\n";
		if (tarball != null && tarball != "" && directoryName != null) {
			output = output.replace("_TARBALL_", tarball);
			output = output.replace("_SRC_DIR_", directoryName);
		} else {
			output = output.replace("TARBALL=\"_TARBALL_\"\n", "");
			output = output.replace("tar -xf $TARBALL\n", "");
			output = output.replace("SRC_DIR=\"_SRC_DIR_\"\n", "");
			output = output.replace("cd $SRC_DIR\n", "");
			output = output.replace("rm -rf $SRC_DIR\n", "");
		}
		return output;
	}*/

	public String toString() {
		return name + " " + dependencies + " " + downloadUrls;
	}
	public BLFSPackage clone() throws CloneNotSupportedException {
		return (BLFSPackage) super.clone();
	}
}
