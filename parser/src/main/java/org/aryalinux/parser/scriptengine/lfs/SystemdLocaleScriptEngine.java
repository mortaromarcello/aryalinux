package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.LineExtractor;
import org.aryalinux.parser.utils.Util;

public class SystemdLocaleScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("locale.html")) {
				step.setCommands(LineExtractor.extract(step.getCommands(),
						"cat > /etc/locale.conf << \"EOF\"", "EOF"));
				step.setCommands(step
						.getCommands()
						.replace(
								"<em class=\"replaceable\"><code><ll>_<CC>.<charmap><@modifiers></em>",
								"$LOCALE"));
				String filePath = LFSParser.outputDirectory + File.separator
						+ (LFSParser.mainScriptIndex++) + ".sh";
				Util.writeFile(filePath, step.toDefaultString());
			}
		}
	}

}
