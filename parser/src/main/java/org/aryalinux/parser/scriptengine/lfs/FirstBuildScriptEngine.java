package org.aryalinux.parser.scriptengine.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.lfs.LFSParser;

public class FirstBuildScriptEngine extends ScriptEngine {

	@Override
	public void generateScript(List<Step> steps, String outputDirectory)
			throws Exception {
		InputStream inputStream = getClass().getClassLoader()
				.getResourceAsStream("first-build-script-template");
		byte[] data = new byte[inputStream.available()];
		inputStream.read(data);
		inputStream.close();
		Step kernfs = null, chroot = null;
		for (Step step : steps) {
			if (step.getSource().equals("kernfs.html")) {
				kernfs = step;
			} else if (step.getSource().equals("chroot.html")) {
				chroot = step;
			}
		}
		if (kernfs != null && chroot != null) {
			String kernfsCommands = kernfs.getCommands();
			String chrootCommands = chroot.getCommands();
			String output = new String(data);
			output = output.replace("[_KERNFS_]", kernfsCommands);
			output = output.replace("[_CHROOT_]", chrootCommands);
			FileOutputStream fileOutputStream = new FileOutputStream(new File(
					outputDirectory + File.separator
							+ (LFSParser.mainScriptIndex++) + ".sh"));
			fileOutputStream.write(output.getBytes());
			fileOutputStream.close();
		}
	}

}
