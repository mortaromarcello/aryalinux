package blfsparser;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Parser {
	private Element document;
	private List<String> downloadUrls;
	private String name;
	private Set<String> required, recommended, optional;
	private List<String> commands;
	private String subSection;

	protected Parser() {
		downloadUrls = new ArrayList<String>();
		required = new LinkedHashSet<String>();
		recommended = new LinkedHashSet<String>();
		optional = new LinkedHashSet<String>();
		commands = new ArrayList<String>();
	}

	public Parser(String name, Element document, String subSection) throws Exception {
		this();
		this.name = name;
		this.document = document;
		this.subSection = subSection;
	}

	public Parser(String name, String path, String subSection) throws Exception {
		this();
		this.name = name;
		this.document = Jsoup.parse(Util.readFileEncode(path));
		this.subSection = subSection;
	}

	public String getName() {
		return name;
	}

	public List<String> getCommands() {
		return commands;
	}

	public void setCommands(List<String> commands) {
		this.commands = commands;
	}

	public Set<String> getRequiredDependencies() {
		return required;
	}

	public Set<String> getRecommendedDependencies() {
		return recommended;
	}

	public Set<String> getOptionalDependencies() {
		return optional;
	}

	public String getSubSection() {
		return subSection;
	}

	protected Element getDocument() {
		return this.document;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setDocument(Element document) {
		this.document = document;
	}

	private void parseDownloadUrls() {
		Elements ulinks = document.select("a.ulink");
		for (Element ulink : ulinks) {
			String href = ulink.attr("href");
			if (Util.isValidTarballDownloadUrl(href)) {
				downloadUrls.add(href);
			}
		}
	}

	private String parseDependencyLinkString(String dependencyString) {
		String processed = dependencyString;
		if (processed.startsWith("..")) {
			processed = processed.replace("../", "");
		}
		if (processed.indexOf('/') == -1) {
			processed = subSection + "_" + processed;
		}
		processed = processed.replace("/", "_");
		processed = processed.replace(".html", "");
		if (!BLFSParser.namesToNormalize.contains(processed)) {
			processed = processed.substring(processed.indexOf('_') + 1);
		}
		return processed;
	}

	private void parseDependencies() {
		Elements requiredLinks = document.select("p.required a.xref");
		Elements recommendedLinks = document.select("p.recommended a.xref");
		Elements optionalLinks = document.select("p.optional a.xref");
		for (Element element : requiredLinks) {
			/*
			 * if (element.attr("href").contains("glibmm")) {
			 * System.out.println(element.attr("href"));
			 * System.out.println(element.attr("href").substring(element.attr(
			 * "href").indexOf('/') + 1)); }
			 */
			required.add(parseDependencyLinkString(element.attr("href")));
			// required.add(element.attr("href").substring(element.attr("href").indexOf('/')
			// + 1));
		}
		for (Element element : recommendedLinks) {
			recommended.add(parseDependencyLinkString(element.attr("href")));
			// recommended.add(element.attr("href").substring(element.attr("href").indexOf('/')
			// + 1));
		}
		for (Element element : optionalLinks) {
			optional.add(parseDependencyLinkString(element.attr("href")));
			// optional.add(element.attr("href").substring(element.attr("href").indexOf('/')
			// + 1));
		}
	}

	public void setSubSection(String subSection) {
		this.subSection = subSection;
	}

	private void parseCommands() {
		Elements commandElements = document.select("pre.userinput, pre.root");
		for (Element commandElement : commandElements) {
			Element internal = commandElement.select("kbd.command").first();
			if (internal != null) {
				if (commandElement.attr("class").equals("userinput")) {
					commands.add("USER_INPUT:" + internal.html());
				} else {
					commands.add("ROOT_COMMANDS:" + internal.html());
				}
			}
		}
	}

	public void parse() {
		parseDownloadUrls();
		parseDependencies();
		parseCommands();
	}

	public List<String> getDownloadUrls() {
		return downloadUrls;
	}

	public String generate() throws Exception {
		if (commands.size() <= 0) {
			return null;
		}
		StringBuilder builder = new StringBuilder();
		builder.append("#!/bin/bash\n\n");
		builder.append("set -e\n\n");
		builder.append(". /etc/alps/alps.conf\n. /var/lib/alps/functions\n\n");
		for (String str : required) {
			builder.append("#REQ:" + str.replace(".html", "") + '\n');
		}
		for (String str : recommended) {
			builder.append("#REC:" + str.replace(".html", "") + '\n');
		}
		for (String str : optional) {
			builder.append("#OPT:" + str.replace(".html", "") + '\n');
		}
		builder.append("\n");
		builder.append("\ncd $SOURCE_DIR\n\n");
		if (downloadUrls.size() > 0) {
			builder.append("URL=" + downloadUrls.get(0) + "\n\n");

			for (String downloadUrl : downloadUrls) {
				builder.append("wget -nc " + downloadUrl + "\n");
			}
			builder.append("\n");
			builder.append("TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`\n");
			if (!downloadUrls.get(0).endsWith(".zip")) {
				builder.append("DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`\n\n");
			} else {
				builder.append("DIRECTORY=''\nunzip_dirname $TARBALL DIRECTORY\n\n");
			}
			if (!downloadUrls.get(0).endsWith(".zip")) {
				builder.append("tar xf $TARBALL\n");
			} else {
				builder.append("unzip_file $TARBALL\n");
			}
			builder.append("cd $DIRECTORY\n\n");
		}
		for (String cmd : commands) {
			if (cmd.startsWith("USER_INPUT:")) {
				builder.append(cmd.replace("br3ak", "\n").replace("USER_INPUT:", "") + "\n");
			} else {
				String str = cmd.replace("br3ak", "\n").replace("ROOT_COMMANDS:", "");
				if (str.trim().startsWith("make install-") && !str.trim().startsWith("make install-full")) {
					str = "wget -nc " + BLFSParser.systemdUnits + " -O $SOURCE_DIR/" + BLFSParser.systemdUnitsTarball
							+ "\ntar xf $SOURCE_DIR/" + BLFSParser.systemdUnitsTarball + " -C .\ncd "
							+ BLFSParser.systemdUnitsTarball.replace(".tar.bz2", "") + "\n" + str + "\ncd ..";
				}
				builder.append(Util.wrapRootCommands(str) + "\n");
			}
			builder.append("\n");
		}
		builder.append("cd $SOURCE_DIR\n\n");
		if (downloadUrls.size() > 0) {
			builder.append("sudo rm -rf $DIRECTORY\n");
		}
		if (!BLFSParser.namesToNormalize.contains(subSection + "_" + name)) {
			builder.append("echo \"" + name + "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n");
		}
		else {
			builder.append("echo \"" + subSection + '_' + name + "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n");
		}
		return Util.removeEntities(builder.toString());
	}

}
