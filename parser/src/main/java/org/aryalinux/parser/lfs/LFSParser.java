package org.aryalinux.parser.lfs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.StringTokenizer;

import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

/**
 * Hello world!
 * 
 */
public class LFSParser {
	private static List<String> tarballs;
	public static String template = "/home/chandrakant/script-template";
	public static String sourcePath = "/mnt/lfs/sources";
	public static String logPath = "/mnt/lfs/sources/install-log";
	public static Boolean useDefaultTemplate = true;
	public static String rootDirectory = "/home/chandrakant/Downloads/7.7";
	public static String outputDirectory = "/home/chandrakant/Desktop/7.7-scripts";
	public static List<Step> steps;
	public static List<String> expendables;
	public static int mainScriptIndex = 1;
	public static boolean isSystemd = false;
	public static LinkedHashMap<String, String> tarCorrections;

	static {
		steps = new ArrayList<Step>();
		try {
			tarballs = new ArrayList<String>();
			tarCorrections = new LinkedHashMap<String, String>();
			expendables = new ArrayList<String>();
			expendables.add("chapter01");
			expendables.add("chapter02");
			expendables.add("chapter03");
			expendables.add("chapter04");
			expendables.add("chapter05");
			expendables.add("chapter07");
			expendables.add("chapter08");
			expendables.add("chapter09");
			expendables.add("chapter06/6.01.sh");
			expendables.add("chapter06/6.02.sh");
			expendables.add("chapter06/6.03.sh");
			expendables.add("chapter06/6.04.sh");
			expendables.add("chapter06/6.05.sh");
			expendables.add("chapter06/6.06.sh");
			expendables.add("aboutdebug.html");
			expendables.add("strippingagain.html");
			expendables.add("revisedchroot.html");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void loadTarCorrectionMap() throws Exception {
		BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(LFSParser.class.getClassLoader()
						.getResourceAsStream("tar-map.properties")));
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			StringTokenizer parts = new StringTokenizer(line, "?");
			tarCorrections.put(parts.nextToken(), parts.nextToken());
		}
		bufferedReader.close();
	}

	public static void startParsing() throws Exception {
		initTarballs(rootDirectory + File.separator + "wget-list");
		loadTarCorrectionMap();
		File outRoot = new File(outputDirectory);
		String indexPageData = Util.readFileSimple(rootDirectory
				+ File.separator + "index.html");
		Document rootDoc = Jsoup.parse(indexPageData);
		if (rootDoc.select("h2.subtitle").html().trim().contains("systemd")) {
			isSystemd = true;
		}
		Elements pageLinks = rootDoc.select("li.chapter ul li.sect1 a");
		File outputDir = new File(outputDirectory);
		outputDir.mkdirs();
		for (Element link : pageLinks) {
			String href = link.attr("href");
			String pagePath = rootDirectory + File.separator + href;
			Document doc = Jsoup.parse(Util.readFile(pagePath));
			Step step = new Step();
			steps.add(step);
			step.setSource(href.substring(href.lastIndexOf('/') + 1));
			String heading = doc.select("h1.sect1").text().replace("br3ak", "")
					.trim();
			String tarball = getTarball(heading);
			if (tarball == null) {
				step.setType(0);
			} else {
				step.setType(1);
			}
			step.setTarball(tarball);
			step.setDirectory(Util.getDirectory(tarball));
			Elements commandElements = doc.select("kbd.command");
			String commands = "";
			for (Element commandElement : commandElements) {
				commands = commands + commandElement.html() + "\n";
			}
			commands = commands.replace("br3ak", "\n");
			step.setCommands(commands);

			File pagePathFile = new File(pagePath);
			String dirName = pagePathFile.getParentFile().getName();

			File newDir = new File(outRoot, dirName);
			newDir.mkdirs();
			String index = heading.split(" ")[0];
			index = index.substring(0, index.length() - 1);
			step.setIndex(index);

			String scriptName = pagePath.substring(
					pagePath.lastIndexOf('/') + 1).replace(".html", "");
			step.setScriptName(scriptName);
			step.setStepName(heading);

			step.setCommands(Util.reformat(step.getCommands()));

			PostProcessorEngine.process(step);

			FileOutputStream fileOutputStream = new FileOutputStream(new File(
					newDir, step.getIndex() + ".sh"));
			String scriptData = null;
			if (!LFSParser.useDefaultTemplate) {
				scriptData = step.toString();
			} else {
				scriptData = step.toDefaultString();
			}
			fileOutputStream.write(scriptData.getBytes());
			fileOutputStream.close();
			File f = new File(newDir, step.getIndex() + ".sh");
			f.setExecutable(true);
		}
		if (isSystemd) {
			SystemdStageScriptEngine.instance()
					.generate(steps, outputDirectory);
		} else {
			StageScriptEngine.instance().generate(steps, outputDirectory);
		}
		PostLFSGenerator.generate();
		ScriptFinalizerEngine.instance().finalizeScripts();

		for (String expendable : expendables) {
			File f = new File(outputDirectory, expendable);
			if (f.isDirectory() || expendable.endsWith(".sh")) {
				Util.delete(outputDirectory + File.separator + expendable);
			} else if (expendable.endsWith(".html")) {
				for (Step step : steps) {
					if (step.getSource().equals(expendable)) {
						String index = step.getIndex();
						//new File(outputDirectory + File.separator + "chapter06"
							//	+ File.separator + index + ".sh").delete();
					}
				}
			}
		}
	}

	private static void initTarballs(String wgetListPath) throws Exception {
		BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(new FileInputStream(wgetListPath)));
		String str = null;
		while ((str = bufferedReader.readLine()) != null) {
			if (!str.endsWith(".patch") && !str.contains("manpages")) {
				tarballs.add(str.substring(str.lastIndexOf('/') + 1));
			}
		}
		bufferedReader.close();
	}

	private static String getTarball(String heading) {
		String[] components = heading.split(" ");
		String raw = components[1].toLowerCase();
		String tarball = null;
		for (String str : tarballs) {
			if (str.toLowerCase().startsWith(raw.toLowerCase())) {
				tarball = str;
			}
		}
		if (tarball == null) {
			raw = getCorrectedRaw(raw);
			if (raw != null) {
				for (String str : tarballs) {
					if (str.toLowerCase().startsWith(raw.toLowerCase())) {
						tarball = str;
					}
				}
			}
		}
		return tarball;
	}

	private static String getCorrectedRaw(String raw) {
		for (Entry<String, String> entry : tarCorrections.entrySet()) {
			if (raw.startsWith(entry.getKey())) {
				return entry.getValue();
			}
		}
		return null;
	}
}
