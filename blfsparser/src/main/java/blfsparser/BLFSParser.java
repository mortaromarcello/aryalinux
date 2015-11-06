package blfsparser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class BLFSParser {
	private static String parent;
	private static String outputDir;
	public static String systemdUnits = null;
	public static String systemdUnitsTarball = null;
	public static List<String> systemdDownloads = new ArrayList<String>();
	public static String dbusLink = null;
	public static Map<String, List<String>> names = new LinkedHashMap<String, List<String>>();
	public static List<String> namesToNormalize = new ArrayList<String>();

	static {
		systemdDownloads.add("http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-224.tar.xz");
		systemdDownloads.add("http://www.linuxfromscratch.org/patches/downloads/systemd/systemd-224-compat-3.patch");
		systemdDownloads.add("http://www.linuxfromscratch.org/patches/downloads/systemd/systemd-224-compat-1.patch");
		dbusLink = "http://dbus.freedesktop.org/releases/dbus/dbus-1.8.18.tar.gz";
	}

	private static void normalizeNames() {
		Set<String> nameSet = new HashSet<String>();
		for (String name: names.keySet()) {
			nameSet.add(name);
		}
		for (String name: nameSet) {
			if (name.equals("libglade")) {
			}
			if (names.get(name).size() == 1) {
				names.remove(name);
			}
		}
		for (Entry<String, List<String>> entry : names.entrySet()) {
			namesToNormalize.addAll(entry.getValue());
		}
	}
	
	public static void generateExtraScripts() throws Exception {
		InputStream inputStream = BLFSParser.class.getClassLoader()
				.getResourceAsStream("blfsparser/extrascripts/scripts");
		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			InputStream inputStream2 = BLFSParser.class.getClassLoader()
					.getResourceAsStream("blfsparser/extrascripts/" + line);
			FileOutputStream fout = new FileOutputStream(outputDir + File.separator + line);
			byte[] data = new byte[inputStream2.available()];
			inputStream2.read(data);
			fout.write(data);
			fout.close();
			inputStream2.close();
			File file = new File(outputDir + File.separator + line);
			file.setExecutable(true);
		}
		inputStream.close();
	}

	public static void main(String[] args) throws Exception {
		String indexPath = "/home/chandrakant/blfs-svn/index.html";
		String outDir = "/home/chandrakant/blfs-generated";

		Document document = Jsoup.parse(new File(indexPath), "utf8");
		parent = indexPath.substring(0, indexPath.lastIndexOf('/'));
		outputDir = outDir;
		Elements pageLinks = document.select("li.sect1 a");
		for (Element pageLink: pageLinks) {
			String href = pageLink.attr("href");
			String name = href.substring(href.lastIndexOf('/') + 1).replace(".html", "");
			String subDir = href.substring(0, href.lastIndexOf('/'));
			if (names.get(name) == null) {
				names.put(name, new ArrayList<String>());
			}
			names.get(name).add(subDir + "_" + name);
		}
		normalizeNames();
		for (Element pageLink : pageLinks) {
			String href = pageLink.attr("href");
			String name = href.substring(href.lastIndexOf('/') + 1).replace(".html", "");
			String subDir = href.substring(0, href.lastIndexOf('/'));
			// new File(outputDir + File.separator + subDir).mkdirs();
			String sourceFile = parent + File.separator + href;
			Parser parser = null;
			if (href.contains("x7driver")) {
				parser = new XorgDriverParser(name, sourceFile, subDir);
			} else if (href.endsWith("freetype2.html")) {
				parser = new Parser(name, sourceFile, subDir);
				Parser parser1 = new Parser(name, sourceFile, subDir);
				parser1.getRecommendedDependencies().remove("freetype2.html");
				parser1.getRecommendedDependencies().remove("harfbuzz.html");
				parser.parse();
				parser1.parse();
				parser1.setName("freetype2-without-harfbuzz");
				Util.replaceCommandContaining(parser1, parser1.getName(), "./configure --prefix=/usr",
						"./configure --prefix=/usr --without-harfbuzz");
				RulesEngine.applyRules(parser1);
				String generated = parser1.generate();
				// System.out.println(generated);
				FileOutputStream output = new FileOutputStream(
						outputDir + File.separator + "freetype2-without-harfbuzz.sh");
				output.write(generated.getBytes());
				output.close();
				File file = new File(outputDir + File.separator + "freetype2-without-harfbuzz.sh");
				file.setExecutable(true);
			} else if (href.contains("python-modules")) {
				parser = new PythonModulesParser(name, sourceFile, subDir);
				parser.parse();
				List<Parser> parsers = ((PythonModulesParser) parser).getAllParsers();
				for (Parser pythonModuleParser : parsers) {
					String generated = pythonModuleParser.generate();
					FileOutputStream fileOutputStream = new FileOutputStream(
							outputDir + File.separator + pythonModuleParser.getName() + ".sh");
					fileOutputStream.write(generated.getBytes());
					fileOutputStream.close();
					File file = new File(
							outputDir + File.separator + pythonModuleParser.getName() + ".sh");
					file.setExecutable(true);
				}
				continue;
			} else if (href.contains("perl-modules")) {
				parser = new PythonModulesParser(name, sourceFile, subDir);
				Element doc = parser.getDocument();
				PerlModuleParser moduleParser = new PerlModuleParser();
				moduleParser.parse(doc);
				moduleParser.generate(outputDir);
				continue;
			} else if (href.contains("libva-drivers")) {
				parser = new PythonModulesParser(name, sourceFile, subDir);
				Element doc = parser.getDocument();
				Elements sections = doc.select("div.sect2");
				for (Element section : sections) {
					Parser p = new Parser();
					p.setDocument(section);
					p.setName(section.select("a").first().attr("id"));
					p.setSubSection("multimedia");
					p.parse();
					String output = p.generate();
					FileOutputStream fout = new FileOutputStream(
							outputDir + File.separator + p.getName() + ".sh");
					fout.write(output.getBytes());
					fout.close();
					File file = new File(outputDir + File.separator + p.getName() + ".sh");
					file.setExecutable(true);
				}
			} else {
				parser = new Parser(name, sourceFile, subDir);
			}
			parser.parse();
			//if (parser.getName().contains("libxfcegui4")) {
				// System.out.println(parser.getName());
			//}
			RulesEngine.applyRules(parser);
			String generated = parser.generate();
			if (pageLink.attr("href").contains("systemd-units")) {
				systemdUnits = parser.getDownloadUrls().get(0);
				systemdUnitsTarball = systemdUnits.substring(systemdUnits.lastIndexOf('/') + 1);
				continue;
			}
			if (generated != null) {
				String filename = null;
				FileOutputStream output = null;
				if (!namesToNormalize.contains(parser.getSubSection() + "_" + parser.getName())) {
					filename = href.replace("/", "_").replace(".html", ".sh");
					filename = outputDir + File.separator + filename.substring(filename.indexOf('_') + 1);
					//System.out.println("Generating " + filename);
					output = new FileOutputStream(filename);
				}
				else {
					filename = outputDir + File.separator + href.replace("/", "_").replace(".html", ".sh");
					//System.out.println("Generating " + filename);
					output = new FileOutputStream(filename);
				}
				output.write(generated.getBytes());
				output.close();
				File file = new File(filename);
				file.setExecutable(true);
			} else {
				// System.out.println(parser.getName() + " gave null");
			}
		}
		/*
		 * Parser parser = new Parser(); parser.setName("npth");
		 * parser.setSubSection("general");
		 */
		generateExtraScripts();
	}
}
