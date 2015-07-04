package org.aryalinux.parser.postprocessor.lfs;

import java.util.LinkedHashMap;

import org.aryalinux.parser.commons.lfs.LFSPostProcessor;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.utils.Eliminator;
import org.aryalinux.parser.utils.Util;

public class MultithreadedMakeCommandPostProcessor implements LFSPostProcessor {

	public void process(Step step) {
		String commands = step.getCommands();
		commands = Util.reformat(commands);
		LinkedHashMap<String, String> replaceables = new LinkedHashMap<String, String>();
		replaceables.put("\nmake\n", "\nmake \"-j`nproc`\"\n");
		replaceables
				.put("make tooldir=/usr", "make \"-j`nproc`\" tooldir=/usr");
		replaceables.put("make SHLIB_LIBS=-lncurses",
				"make \"-j`nproc`\" SHLIB_LIBS=-lncurses");
		replaceables.put("make LIBRARY_PATH=/tools/lib",
				"make \"-j`nproc`\" LIBRARY_PATH=/tools/lib");
		commands = Eliminator.eliminate(replaceables, commands);
		step.setCommands(commands);
	}
}
