package org.aryalinux.parser.blfs;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.util.LinkedHashMap;

import javax.swing.JLabel;
import javax.swing.JOptionPane;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.ui.blfs.BLFSParserUI;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.context.ApplicationContext;

public class BLFSParser {
	public static String bookDirectory;
	public static String outputDirectory;
	public static ApplicationContext applicationContext;
	public static String PACKAGE_DB = "d:\\experiments\\7.7-packages.dat";
	public static LinkedHashMap<String, BLFSPackage> packages = new LinkedHashMap<String, BLFSPackage>();

	public static void startParsing(JLabel status) throws Exception {
		status.setText("Parsing ...");
		Document document = Jsoup.parse(Util.readFileSimple(bookDirectory
				+ File.separator + "index.html"));
		Elements linkElements = document.select("li.chapter ul li a");
		File directory = new File(outputDirectory);
		directory.mkdirs();
		for (Element link : linkElements) {
			if (link.attr("href").contains("x7driver.html")) {
				X7DriverPageParser.x7DriverPage = bookDirectory
						+ File.separator + link.attr("href");
				X7DriverPageParser.outputDirectory = outputDirectory;
				X7DriverPageParser.parse();
				continue;
			}
			if (link.attr("href").contains("python-modules.html")) {
				PythonModulesParser.pythonModulesPage = bookDirectory
						+ File.separator + link.attr("href");
				PythonModulesParser.outputDirectory = outputDirectory;
				PythonModulesParser.parse();
				continue;
			}
			String page = link.attr("href");
			String pagePath = bookDirectory + File.separator + page;
			Document doc = Jsoup.parse(Util.readFile(pagePath));
			BLFSPackage pack = new BLFSPackage();
			if (doc.toString().contains("doxygen")) {
				pack.setDependsOnDoxygen(true);
			}
			pack.setName(page.substring(page.lastIndexOf('/') + 1).replace(
					".html", ""));
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
				dep = dep.substring(dep.lastIndexOf('/') + 1);
				dep = dep.replace(".html", "");
				pack.getDependencies().add(dep);
			}
			Elements optDeps = doc.select("p.optional a");
			for (Element e : optDeps) {
				String dep = e.attr("href");
				pack.getOptionalDeps().add(
						dep.substring(dep.lastIndexOf("/") + 1));
			}
			Elements cmds = doc.select("pre.userinput, pre.root");
			for (Element cmd : cmds) {
				Element prevElement = cmd.previousElementSibling();
				UserCommand command = new UserCommand(Util.reformat(cmd.select(
						"kbd.command").html()), cmd.attr("class"));
				if (doc.toString().contains("doxygen.html")
						|| doc.toString().contains("texlive.html")) {
					if (prevElement.tagName().equals("p")
							&& (prevElement.html().contains("doxygen")
									|| prevElement.html().contains("texlive")
									|| prevElement.html().contains(
											"documentation")
									|| prevElement.html().contains(
											"Documentation") || command
									.getCommand().contains("doxygen"))) {
						command.setDocCommand(true);
					}
				}
				pack.getCommands().add(command);
			}

			CommandPostProcessingEngine.instance().process(pack);

			packages.put(pack.getName(), pack);

			Util.writePackageScript(pack);

			/*
			 * PackageDAO dao =
			 * (PackageDAO)applicationContext.getBean("packageDAO");
			 * dao.savePackage(Util.toPackageEntity(pack));
			 */
		}

		MetaPackageBuilderEngine.instance().createMetaPackageScripts();

		status.setText("Done :-)");

		ObjectOutputStream objectOutputStream = new ObjectOutputStream(
				new FileOutputStream(new File(PACKAGE_DB)));
		objectOutputStream.writeObject(packages);
		objectOutputStream.close();

		JOptionPane.showMessageDialog(BLFSParserUI.instance,
				"Scripts generation complete. Click Ok to Exit.");
		System.exit(0);
	}
}
