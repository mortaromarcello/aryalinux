package org.aryalinux.parser.postprocessor.blfs;

import java.util.LinkedHashSet;
import java.util.Set;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class FreetypePostProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) throws Exception {
		if (pack.getName().equals("freetype2")) {
			pack.getDependencies().remove("freetype2");
			BLFSPackage ftwohb = pack.clone();
			ftwohb.setName("freetype2wohb");
			//ftwohb.setDependencies(cloneList(pack.getDependencies()));
			ftwohb.getDependencies().remove("harfbuzz");
			String commands = Util.unify(ftwohb.getCommands());
			commands = commands
					.replace("./configure --prefix=/usr --disable-static &&",
							"./configure --prefix=/usr --disable-static --without-harfbuzz &&");
			ftwohb.getCommands().clear();
			ftwohb.getCommands().add(new UserCommand(commands, "root"));
			Util.writePackageScript(ftwohb);
		} else if (pack.getName().equals("harfbuzz")) {
			pack.getDependencies().remove("freetype2");
			pack.getDependencies().remove("harfbuzz");
			pack.getDependencies().add("freetype2wohb");
		}
	}

	private Set<String> cloneList(Set<String> source) {
		LinkedHashSet<String> copy = new LinkedHashSet<String>();
		for (String str : source) {
			copy.add(str);
		}
		return copy;
	}
}