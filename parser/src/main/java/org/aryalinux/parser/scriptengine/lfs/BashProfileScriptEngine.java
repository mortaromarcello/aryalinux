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

public class BashProfileScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("profile.html")) {
				String commands = Util.reformat(step.getCommands());
				String newCommands = LineExtractor.extract(commands,
						"cat > /etc/profile << \"EOF\"", "EOF");
				LinkedHashMap<String, String> replaceables = new LinkedHashMap<String, String>();
				replaceables.put("\"EOF\"", "EOF");
				replaceables
						.put("<em class=\"replaceable\"><code><ll>_<CC>.<charmap><@modifiers></em>",
								"$LOCALE");
				newCommands = Eliminator.eliminate(replaceables, newCommands);
				step.setCommands(newCommands);
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
