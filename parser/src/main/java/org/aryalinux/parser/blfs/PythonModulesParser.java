package org.aryalinux.parser.blfs;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class PythonModulesParser {
	public static String pythonModulesPage;
	public static String outputDirectory;

	public static void parse() throws Exception {
		Document doc = Jsoup.parse(Util.readFile(pythonModulesPage));
		Elements sectionLinks = doc
				.select("div.sect1 div.package div.itemizedlist ul.compact li p a.xref");
		Elements sections = doc.select("div.sect2");
		for (Element sectionLink : sectionLinks) {
			String moduleName = sectionLink.attr("href");
			moduleName = moduleName.replace(".html", "");
			for (Element section : sections) {
				if (("python-modules#" + section.select("h2.sect2 a").first()
						.attr("name")).equals(moduleName)) {
					BLFSPackage pack = new BLFSPackage();
					if (section.toString().contains("doxygen")) {
						pack.setDependsOnDoxygen(true);
					}
					Elements downloadUrlElements = section
							.select("div.itemizedlist ul.compact li p:contains(Download (HTTP):) a, div.itemizedlist ul.compact li p:contains(Download (FTP):) a, div.itemizedlist ul.compact li p:contains(patch:) a");
					for (Element downloadUrlElement : downloadUrlElements) {
						pack.getDownloadUrls().add(
								downloadUrlElement.attr("href"));
					}
					if (pack.getDownloadUrls().size() > 0) {
						String url = pack.getDownloadUrls().get(0);
						String tarball = url
								.substring(url.lastIndexOf('/') + 1);
						pack.setTarball(tarball);
						pack.setDirectoryName(Util.getDirectory(tarball));
					}
					Elements deps = section
							.select("p.required a, p.recommended a");
					for (Element e : deps) {
						String dep = e.attr("href");
						dep = dep.substring(dep.lastIndexOf('/') + 1);
						dep = dep.replace(".html", "");
						pack.getDependencies().add(dep);
					}
					Elements optDeps = section.select("p.optional a");
					for (Element e : optDeps) {
						String dep = e.attr("href");
						pack.getOptionalDeps().add(
								dep.substring(dep.lastIndexOf("/") + 1));
					}
					Elements cmds = section.select("pre.userinput pre.root");
					for (Element cmd : cmds) {
						pack.getCommands().add(
								new UserCommand(Util.reformat(cmd.select(
										"kbd.command").html()), cmd
										.attr("class")));
					}

					pack.setName(moduleName);
					//CommandPostProcessingEngine.instance().process(pack);

					NewBLFSParser.packages.put(pack.getName(), pack);
				}
			}
		}
	}
}
