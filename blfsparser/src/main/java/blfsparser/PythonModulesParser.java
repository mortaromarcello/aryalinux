package blfsparser;

import java.util.ArrayList;
import java.util.List;

import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class PythonModulesParser extends Parser {
	List<Parser> parsers = new ArrayList<Parser>();

	public PythonModulesParser(String name, String path, String subSection) throws Exception {
		super(name, path, subSection);
		Element theDocument = getDocument();
		Elements sections = theDocument.select("div.sect2");
		for (Element section : sections) {
			String sectionName = section.select("h2.sect2 a").first().attr("name");
			parsers.add(new Parser("python-modules#" + sectionName, section, "general"));
		}
	}

	public void parse() {
		for (Parser parser : parsers) {
			parser.parse();
		}
	}

	public List<Parser> getAllParsers() {
		return parsers;
	}

	public String generate() throws Exception {
		StringBuilder builder = new StringBuilder();
		builder.append("#!/bin/bash\n\n");
		builder.append("set -e\n\n");
		builder.append(". /etc/alps/alps.conf\n. /var/lib/alps/functions\n\n");
		builder.append("## Individual drivers starts from here... ##\n\n");

		for (Parser parser : parsers) {
			/*
			 * if (parser.getCommands().size() <= 0) { return null; }
			 */
			builder.append("\n# Start of driver installation #\n\n");
			for (String str : parser.getRequiredDependencies()) {
				builder.append("#REQ:" + str.replace(".html", "") + '\n');
			}
			for (String str : parser.getRecommendedDependencies()) {
				builder.append("#REC:" + str.replace(".html", "") + '\n');
			}
			for (String str : parser.getOptionalDependencies()) {
				builder.append("#OPT:" + str.replace(".html", "") + '\n');
			}
			builder.append("\n");
			builder.append("\ncd $SOURCE_DIR\n\n");
			if (parser.getDownloadUrls().size() > 0) {
				builder.append("URL=" + parser.getDownloadUrls().get(0) + "\n\n");

				for (String downloadUrl : parser.getDownloadUrls()) {
					builder.append("wget -nc " + downloadUrl + "\n");
				}
				builder.append("\n");
				builder.append("TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`\n");
				if (!parser.getDownloadUrls().get(0).endsWith(".zip")) {
					builder.append("DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`\n\n");
				} else {
					builder.append("DIRECTORY=''\nunzip_dirname $TARBALL DIRECTORY\n\n");
				}
				if (!parser.getDownloadUrls().get(0).endsWith(".zip")) {
					builder.append("tar xf $TARBALL\n");
				} else {
					builder.append("unzip_file $TARBALL\n");
				}
				builder.append("cd $DIRECTORY\n\n");
			}
			for (String cmd : parser.getCommands()) {
				if (cmd.startsWith("USER_INPUT:")) {
					builder.append(cmd.replace("br3ak", "\n").replace("USER_INPUT:", "") + "\n");
				} else {
					String str = cmd.replace("br3ak", "\n").replace("ROOT_COMMANDS:", "");
					if (str.trim().startsWith("make install-")) {
						str = "wget -nc " + BLFSParser.systemdUnits + " -O $SOURCE_DIR/"
								+ BLFSParser.systemdUnitsTarball + "\ntar xf $SOURCE_DIR/"
								+ BLFSParser.systemdUnitsTarball + " -C .\ncd "
								+ BLFSParser.systemdUnitsTarball.replace(".tar.bz2", "") + "\n" + str + "\ncd ..";
					}
					builder.append(Util.wrapRootCommands(str) + "\n");
				}
				builder.append("\n");
			}
			builder.append("cd $SOURCE_DIR\n\n");
			if (parser.getDownloadUrls().size() > 0) {
				builder.append("sudo rm -rf $DIRECTORY\n");
			}
			builder.append("\n# End of driver installation #\n\n");
		}
		if (!BLFSParser.namesToNormalize.contains(super.getSubSection() + "_" + super.getName())) {
			builder.append("echo \"" + super.getName()
				+ "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n");
		}
		else {
			builder.append("echo \"" + super.getSubSection() + '_' + super.getName()
					+ "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n");
		}
		return Util.removeEntities(builder.toString());
	}
}
