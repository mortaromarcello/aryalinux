package lfsparser;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Parser {
	private Document document;
	private String tarball;
	private String commands;
	private String stepName;

	public Parser(String documentPath) throws Exception {
		document = Jsoup.parse(Util.readFileSpecial(documentPath));
	}

	public Document getDocument() {
		return document;
	}

	public void setDocument(Document document) {
		this.document = document;
	}

	public String getTarball() {
		return tarball;
	}

	public void setTarball(String tarball) {
		this.tarball = tarball;
	}

	public void setCommands(String commands) {
		this.commands = commands;
	}

	public void setStepName(String stepName) {
		this.stepName = stepName;
	}

	public void getTarball(List<String> tarballs) {
		String title = document.select("title").first().html().replace("&nbsp;", " ").replace("br3ak", "").trim()
				.toLowerCase();
		StringTokenizer stringTokenizer = new StringTokenizer(title, " ");
		stringTokenizer.nextToken();
		List<String> tokens = new ArrayList<String>();
		while (stringTokenizer.hasMoreTokens()) {
			tokens.add(stringTokenizer.nextToken());
		}
		// System.out.println(tokens);
		int index = -1;
		int longestPatternMatch = 0;
		for (int i = 0; i < tarballs.size(); i++) {
			String tarball = tarballs.get(i);
			// System.out.println(tarball);
			for (String token : tokens) {
				if ((tarball.indexOf(token) != -1 || tarball.replace("-", "").replace(":", "")
						.indexOf(token.replace("-", "").replace(":", "")) != -1)
						&& token.length() >= longestPatternMatch) {
					// System.out.println("Matched : " + token + ", " +
					// token.length() + ", " + tarball);
					longestPatternMatch = token.length();
					index = i;
				}
			}
		}
		if (index != -1) {
			this.tarball = tarballs.get(index);
		}
		if (this.tarball == null && this.stepName.contains("XML::Parser")) {
			for (String str : tarballs) {
				if (str.contains("XML-Parser")) {
					this.tarball = str;
				}
			}
		}
	}

	public void getCommands() {
		Elements commands = document.select("kbd.command");
		StringBuilder builder = new StringBuilder();
		for (Element element : commands) {
			builder.append(element.html().replace("br3ak", "\n") + "\n");
		}
		this.commands = builder.toString();
	}

	public String getStepName() {
		this.stepName = document.select("title").html().replace("&nbsp;", " ").replace("br3ak", "").trim();
		return this.stepName;
	}

	public void parse(List<String> tarballs) {
		getStepName();
		getTarball(tarballs);
		getCommands();
	}

	public String generate() {
		StringBuilder builder = new StringBuilder();
		builder.append("#!/bin/bash\n");
		builder.append("set -e\n");
		builder.append("set +h\n\n");
		builder.append(". /sources/build.conf\n\n");
		if (tarball != null) {
			builder.append("TARBALL=" + tarball + "\n\n");
		}
		builder.append("STEPNAME=\"" + stepName + "\"\n\n");
		builder.append("if ! grep \"$STEPNAME\" $BUILD_LOG\n");
		builder.append("then\n\n");
		builder.append("cd $SOURCE_DIR\n");
		if (tarball != null) {
			builder.append("DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`\n\n");
			builder.append("tar xf $TARBALL\n");
			builder.append("cd $DIRECTORY\n");
		}
		builder.append("\n" + commands + "\n");
		builder.append("cd $SOURCE_DIR\n");
		if (tarball != null) {
			builder.append("rm -rf $DIRECTORY\n");
		}
		builder.append("rm -rf gcc-build\n");
		builder.append("rm -rf glibc-build\n");
		builder.append("rm -rf binutils-build\n");
		builder.append("echo \"$STEPNAME\" >> $BUILD_LOG\n\n");
		builder.append("fi\n\n");
		if (commands.trim().equals("")) {
			return null;
		}
		else {
			return builder.toString();
		}
	}
}
