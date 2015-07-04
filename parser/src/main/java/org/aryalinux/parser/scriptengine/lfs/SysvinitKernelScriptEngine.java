package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.util.LinkedHashMap;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Eliminator;
import org.aryalinux.parser.utils.Util;

public class SysvinitKernelScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("kernel.html")) {
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
								"cp ../config ./.config");

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
