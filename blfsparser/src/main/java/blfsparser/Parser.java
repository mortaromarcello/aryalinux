package blfsparser;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Parser {
	private Document document;
	private List<String> downloadUrls;
	private String name;
	private List<String> required, recommended, optional;
	private List<String> commands;
	private String subSection;

	public Parser(String name, String path, String subSection) throws Exception {
		this.name = name;
		this.document = Jsoup.parse(readFileEncode(path));
		downloadUrls = new ArrayList<String>();
		required = new ArrayList<String>();
		recommended = new ArrayList<String>();
		optional = new ArrayList<String>();
		commands = new ArrayList<String>();
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

	public List<String> getRequiredDependencies() {
		return required;
	}

	public List<String> getRecommendedDependencies() {
		return recommended;
	}

	public List<String> getOptionalDependencies() {
		return optional;
	}

	public String getSubSection() {
		return subSection;
	}

	private String readFileEncode(String filePath) throws Exception {
		FileInputStream inputStream = new FileInputStream(filePath);
		byte[] data = new byte[inputStream.available()];
		inputStream.read(data);
		String str = new String(data);
		str = str.replace("\n", "br3ak");
		str = str.replace("=br3ak", "=\n");
		inputStream.close();
		return str;
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

	private String wrapRootCommands(String rawCommands) {
		StringBuilder builder = new StringBuilder();
		builder.append("\n");
		builder.append("cat > rootscript.sh << \"ENDOFROOTSCRIPT\"\n");
		builder.append(rawCommands + "\n");
		builder.append("ENDOFROOTSCRIPT\n");
		builder.append("chmod 755 rootscript.sh\n");
		builder.append("sudo ./rootscript.sh\n");
		builder.append("rm rootscript.sh\n");
		builder.append("\n");
		return builder.toString();
	}

	private String removeEntities(String rawString) {
		rawString = rawString.replace("&amp;", "&");
		rawString = rawString.replace("&lt;", "<");
		rawString = rawString.replace("&gt;", ">");
		rawString = rawString.replace("&quot;", "\"");
		rawString = rawString.replace("&nbsp;", " ");
		rawString = rawString.replace("<code class=\"literal\">", "").replace("</code>", "");
		return rawString;
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
		builder.append(". /etc/alps/alps.conf\n\n");
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
		if (downloadUrls.size() > 0) {
			builder.append("URL=" + downloadUrls.get(0) + "\n\n");

			for (String downloadUrl : downloadUrls) {
				builder.append("wget -nc " + downloadUrl + "\n");
			}
			builder.append("\n");
			builder.append("TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`\n");
			builder.append("DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`\n\n");
			builder.append("tar xf $TARBALL\n");
			builder.append("cd $DIRECTORY\n\n");
		}
		for (String cmd : commands) {
			if (cmd.startsWith("USER_INPUT:")) {
				builder.append(cmd.replace("br3ak", "\n").replace("USER_INPUT:", "") + "\n");
			} else {
				String str = cmd.replace("br3ak", "\n").replace("ROOT_COMMANDS:", "");
				if (str.trim().startsWith("make install-")) {
					str = "wget -nc " + BLFSParser.systemdUnits + " -O $SOURCE_DIR/" + BLFSParser.systemdUnitsTarball
							+ "\ntar xf $SOURCE_DIR/" + BLFSParser.systemdUnitsTarball + " -C .\ncd "
							+ BLFSParser.systemdUnitsTarball.replace(".tar.bz2", "") + "\n" + str + "\ncd ..";
				}
				builder.append(wrapRootCommands(str) + "\n");
			}
			builder.append("\n");
		}
		builder.append("cd $SOURCE_DIR\n\n");
		if (downloadUrls.size() > 0) {
			builder.append("rm -rf $DIRECTORY\n");
		}
		builder.append("echo \"" + subSection + '_' + name + "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n");
		return removeEntities(builder.toString());
	}

}
