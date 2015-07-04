package org.aryalinux.parser.blfs;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class X7DriverPageParser {
	public static String outputDirectory;
	public static String x7DriverPage;

	public static void parse() throws Exception {
		Document document = Jsoup.parse(Util.readFile(x7DriverPage));
		Elements driversLinks = document
				.select("div.itemizedlist ul.compact li p a.xref");
		Elements sections = document.select("div.sect2");
		for (Element element : driversLinks) {
			String section = element.attr("href");
			section = section.substring(section.lastIndexOf("#") + 1);
			Element sectionData = sectionWithHeading(sections, section);
			if (sectionData != null) {
				String name = "x7driver#" + section;
				Elements downloadLinks = sectionData
						.select("div.itemizedlist ul.compact li p:contains(Download (HTTP):) a.ulink, div.itemizedlist ul.compact li p:contains(Download (FTP):) a.ulink, div.itemizedlist ul.compact li p:contains(patch:) a.ulink");
				BLFSPackage pack = new BLFSPackage();
				if (sectionData.toString().contains("doxygen")) {
					pack.setDependsOnDoxygen(true);
				}
				pack.setName(name);
				for (Element downloadLink : downloadLinks) {
					pack.getDownloadUrls().add(downloadLink.attr("href"));
				}
				String firstUrl = null;
				if (pack.getDownloadUrls().size() > 0) {
					firstUrl = pack.getDownloadUrls().get(0);
				}
				if (firstUrl != null) {
					String tarball = firstUrl.substring(firstUrl
							.lastIndexOf("/") + 1);
					String dir = Util.getDirectory(tarball);
					pack.setTarball(tarball);
					pack.setDirectoryName(dir);
					Elements cmds = sectionData
							.select("pre.userinput, pre.root");
					for (Element cmd : cmds) {
						pack.getCommands().add(
								new UserCommand(Util.reformat(cmd.select(
										"kbd.command").html()), cmd
										.attr("class")));
					}
				}
				Elements dependencies = sectionData
						.select("p.required a, p.recommended a");
				for (Element dependency : dependencies) {
					String href = dependency.attr("href");
					href = href.substring(href.lastIndexOf('/') + 1);
					String depLink = href.replace(".html", "");
					pack.getDependencies().add(depLink);
				}
				Elements optDeps = sectionData.select("p.optional a");
				for (Element e : optDeps) {
					String dep = e.attr("href");
					pack.getOptionalDeps().add(
							dep.substring(dep.lastIndexOf("/") + 1));
				}
				//CommandPostProcessingEngine.instance().process(pack);

				NewBLFSParser.packages.put(pack.getName(), pack);
				System.out.println("driver");
			}
		}
	}

	public static Element sectionWithHeading(Elements sections, String heading) {
		Element selectedElement = null;
		for (Element section : sections) {
			Elements headingLink = section.select("h2.sect2 a");
			if (headingLink.size() > 0) {
				Element first = headingLink.get(0);
				String name = first.attr("name");
				if (name.equals(heading)) {
					selectedElement = section;
					break;
				}
			}
		}
		return selectedElement;
	}
}