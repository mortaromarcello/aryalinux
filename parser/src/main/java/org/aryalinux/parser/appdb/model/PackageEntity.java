package org.aryalinux.parser.appdb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "package")
public class PackageEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	@Column
	private String name;
	@Column
	private String version;
	@Column(columnDefinition="blob")
	private String downloadUrls;
	@Column
	private String tarball;
	@Column
	private String extractionDirectory;
	@Column(columnDefinition="blob")
	private String dependencies;
	@Column(columnDefinition="blob")
	private String buildCommands;
	@Column
	private String description;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getDownloadUrls() {
		return downloadUrls;
	}

	public void setDownloadUrls(String downloadUrls) {
		this.downloadUrls = downloadUrls;
	}

	public String getTarball() {
		return tarball;
	}

	public void setTarball(String tarball) {
		this.tarball = tarball;
	}

	public String getExtractionDirectory() {
		return extractionDirectory;
	}

	public void setExtractionDirectory(String extractionDirectory) {
		this.extractionDirectory = extractionDirectory;
	}

	public String getDependencies() {
		return dependencies;
	}

	public void setDependencies(String dependencies) {
		this.dependencies = dependencies;
	}

	public String getBuildCommands() {
		return buildCommands;
	}

	public void setBuildCommands(String buildCommands) {
		this.buildCommands = buildCommands;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}
