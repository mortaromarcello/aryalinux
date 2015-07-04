package org.aryalinux.parser.blfs;

import java.io.File;
import java.util.LinkedHashMap;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class NewBLFSParser {
	public static String bookDirectory;
	public static String outputFile;
	public static LinkedHashMap<String, BLFSPackage> packages;

	public static void main(String[] args) throws Exception {
		packages = new LinkedHashMap<String, BLFSPackage>();
		Document document = Jsoup.parse(Util.readFileSimple(bookDirectory
				+ File.separator + "index.html"));
		Elements linkElements = document.select("li.chapter ul li a");
		for (Element link : linkElements) {
			if (link.attr("href").contains("x7driver.html")) {
				X7DriverPageParser.x7DriverPage = bookDirectory
						+ File.separator + link.attr("href");
				X7DriverPageParser.parse();
				continue;
			}
			if (link.attr("href").contains("python-modules.html")) {
				PythonModulesParser.pythonModulesPage = bookDirectory
						+ File.separator + link.attr("href");
				PythonModulesParser.parse();
				continue;
			}
			if (link.attr("href").contains("perl-modules.html")) {
				continue;
			}

			String page = link.attr("href");
			String pagePath = bookDirectory + File.separator + page;
			Document doc = Jsoup.parse(Util.readFile(pagePath));
			BLFSPackage pack = new BLFSPackage();
			pack.setName(page.replace(".html", ""));
			Elements downloadUrls = doc
					.select("div.itemizedlist ul.compact li p:contains(Download (HTTP):) a, div.itemizedlist ul.compact li p:contains(Download (FTP):) a, div.itemizedlist ul.compact li p:contains(patch:) a, div.itemizedlist ul.compact li p:contains(Required) a, div.itemizedlist ul.compact li p:contains(Recommended) a");
			for (Element e : downloadUrls) {
				String url = e.attr("href");
				pack.getDownloadUrls().add(url);
			}
			if (pack.getDownloadUrls().size() > 0) {
				String url = pack.getDownloadUrls().get(0);
				String tarball = url.substring(url.lastIndexOf('/') + 1);
				if (tarball.trim().equals("")) {
					tarball = null;
				}
				pack.setTarball(tarball);
				pack.setDirectoryName(Util.getDirectory(tarball));
			}
			Elements deps = doc.select("p.required a, p.recommended a");
			for (Element e : deps) {
				String dep = e.attr("href");
				dep = dep.replace(".html", "");
				dep = dep.replace("../", "");
				if (dep.indexOf("/") != -1) {
					String section = pack.getName().substring(0, pack.getName().indexOf('/'));
					dep = section + "/" + dep;
				}
				if (!pack.getDependencies().contains(dep)) {
					pack.getDependencies().add(dep);
				}
			}
			Elements optDeps = doc.select("p.optional a");
			for (Element e : optDeps) {
				String dep = e.attr("href");
				dep = dep.replace(".html", "");
				dep = dep.replace("../", "");
				if (dep.indexOf("/") == -1) {
					String section = pack.getName().substring(0, pack.getName().indexOf('/'));
					dep = section + "/" + dep;
				}
				if (!pack.getOptionalDeps().contains(dep)) {
					pack.getOptionalDeps().add(dep);
				}
			}
			Elements cmds = doc.select("pre.userinput, pre.root");
			for (Element cmd : cmds) {
				UserCommand command = new UserCommand(Util.reformat(cmd.select(
						"kbd.command").html()), cmd.attr("class"));
				pack.getCommands().add(command);
			}
			packages.put(pack.getName(), pack);
		}
	}
}
