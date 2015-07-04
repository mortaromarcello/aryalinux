package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.util.LinkedHashMap;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Eliminator;
import org.aryalinux.parser.utils.LineExtractor;
import org.aryalinux.parser.utils.Util;

public class LSBReleaseScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("theend.html")) {
				String commands = Util.reformat(step.getCommands());
				String newCommands = LineExtractor.extract(commands,
						"cat > /etc/lsb-release << \"EOF\"", "EOF");
				LinkedHashMap<String, String> replaceables = new LinkedHashMap<String, String>();
				replaceables.put("cat > /etc/lsb-release << \"EOF\"",
						"cat > /etc/lsb-release << EOF");
				replaceables.put("Linux From Scratch", "$OS_PRETTY_NAME");
				replaceables.put("<your name here>", "$OS_CODENAME");
				newCommands = Eliminator.eliminate(replaceables, newCommands);
				String[] lines = newCommands.split("\n");
				String finalLines = "";
				for (int i = 0; i < lines.length; i++) {
					if (lines[i].startsWith("DISTRIB_RELEASE=")) {
						lines[i] = "DISTRIB_RELEASE=\"$OS_VERSION\"";
					}
					finalLines = finalLines + lines[i] + "\n";
				}
				step.setCommands(finalLines);
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
