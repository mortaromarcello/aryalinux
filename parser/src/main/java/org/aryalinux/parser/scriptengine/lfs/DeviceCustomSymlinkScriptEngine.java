package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Eliminator;

public class DeviceCustomSymlinkScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		for (Step step : steps) {
			if (step.getSource().equals("symlinks.html")) {
				FileOutputStream fileOutputStream = new FileOutputStream(
						new File(outputDirectory + File.separator
								+ (LFSParser.mainScriptIndex++) + ".sh"));
				String raw = step.toDefaultString();
				Map<String, String> replaceables = new LinkedHashMap<String, String>();
				replaceables.put(
						"cat /etc/udev/rules.d/70-persistent-net.rules", "");
				replaceables.put("udevadm test /sys/block/hdd", "");
				replaceables
						.put("sed -i -e 's/\"write_cd_rules\"/\"write_cd_rules <em class=\"replaceable\"><code>mode</em>\"/' \\",
								"");
				replaceables.put(
						"    /etc/udev/rules.d/83-cdrom-symlinks.rules", "");
				String processed = Eliminator.eliminate(replaceables, raw);
				fileOutputStream.write(processed.getBytes());
				fileOutputStream.close();
			}
		}
	}

}
