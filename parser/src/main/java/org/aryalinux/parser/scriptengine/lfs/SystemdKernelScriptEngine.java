package org.aryalinux.parser.scriptengine.lfs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.StringReader;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.StringTokenizer;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Eliminator;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class SystemdKernelScriptEngine extends ScriptEngine {

	public LinkedHashMap<String, Boolean> getKernelConfigOptions(
			String configOptionsString) throws Exception {
		LinkedHashMap<String, Boolean> options = new LinkedHashMap<String, Boolean>();
		BufferedReader bufferedReader = new BufferedReader(new StringReader(
				configOptionsString));
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			if (line.trim().startsWith("<") || line.trim().startsWith("[")) {
				StringTokenizer st = new StringTokenizer(line.trim(), "[]<>");
				int count = st.countTokens();
				String value = st.nextToken();
				for (int i = 0; i < count - 2; i++) {
					st.nextToken();
				}
				String key = st.nextToken();
				options.put(key, value.equals(" ") ? false : true);
			}
		}
		bufferedReader.close();
		return options;
	}

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("kernel.html")) {
				Document doc = Jsoup
						.parse(Util.readFile(LFSParser.rootDirectory
								+ File.separator + "chapter08" + File.separator
								+ "kernel.html"));
				String configOptionsString = doc.select("pre.screen").html();
				configOptionsString = configOptionsString
						.replace("br3ak", "\n");
				LinkedHashMap<String, Boolean> options = getKernelConfigOptions(Util
						.reformat(configOptionsString));

				String kernelOptionsEnablerString = "";

				for (Entry<String, Boolean> entry : options.entrySet()) {
					if (entry.getValue()) {
						kernelOptionsEnablerString = kernelOptionsEnablerString
								+ "sed -i \"s/# " + entry.getKey()
								+ " is not set/" + entry.getKey()
								+ "=y/g\" .config\n";
					} else {
						kernelOptionsEnablerString = kernelOptionsEnablerString
								+ "sed -i \"s/" + entry.getKey() + "=y/# "
								+ entry.getKey() + " is not set/g\" .config\n";
					}
				}
				kernelOptionsEnablerString = "\n" + kernelOptionsEnablerString;
				String commands = "";
				commands = commands + "patch -Np1 -i ../aufs3-base.patch"
						+ "\n";
				commands = commands + "patch -Np1 -i ../aufs3-kbuild.patch"
						+ "\n";
				commands = commands + "patch -Np1 -i ../aufs3-mmap.patch"
						+ "\n\n";
				commands = commands + "tar -xf ../aufs.tar.gz" + "\n";

				LinkedHashMap<String, String> replaceables = new LinkedHashMap<String, String>();
				replaceables
						.put("make LANG=<em class=\"replaceable\"><code><host_LANG_value></em> LC_ALL= menuconfig",
								"cp ../config ./.config\n"
										+ kernelOptionsEnablerString);

				String firmwareCommands = "\ntar -xf ../firmware.tar.gz -C /\n";

				step.setCommands(commands + "\n"
						+ Util.reformat(step.getCommands()) + firmwareCommands);

				step.setCommands(Eliminator.eliminate(replaceables,
						step.getCommands()));
				FileOutputStream fileOutputStream = new FileOutputStream(
						new File(outputDirectory + File.separator
								+ (LFSParser.mainScriptIndex++) + ".sh"));
				fileOutputStream.write(step.toDefaultString().getBytes());
				fileOutputStream.close();
				break;
			}
		}
	}
}
