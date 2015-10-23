package blfsparser;

import java.util.ArrayList;
import java.util.List;

public class PerlModule {
	private String name;
	private String commands;
	private List<PerlModule> dependencies;
	private String downloadUrl;

	public PerlModule() {
		dependencies = new ArrayList<PerlModule>();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCommands() {
		return commands;
	}

	public void setCommands(String commands) {
		this.commands = commands;
	}

	public List<PerlModule> getDependencies() {
		return dependencies;
	}

	public String getDownloadUrl() {
		return downloadUrl;
	}

	public void setDownloadUrl(String downloadUrl) {
		this.downloadUrl = downloadUrl;
	}

	public void setDependencies(List<PerlModule> dependencies) {
		this.dependencies = dependencies;
	}
	
	public void print(String indent) {
		System.out.println(indent + name + "(" + downloadUrl + ")");
		for(PerlModule module : dependencies) {
			module.print(indent + "    ");
		}
	}
}
