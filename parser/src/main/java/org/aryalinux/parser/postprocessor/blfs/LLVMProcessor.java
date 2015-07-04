package org.aryalinux.parser.postprocessor.blfs;

import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class LLVMProcessor implements BLFSCommandsPostProcessor {

	public void process(BLFSPackage pack) {
		if (pack.getName().equals("llvm")) {
			List<String> downloadUrls = new ArrayList<String>();
			downloadUrls.add(pack.getDownloadUrls().get(0));
			pack.setDownloadUrls(downloadUrls);
			String[] commands = Util.unify(pack.getCommands()).split("\n");
			String finalCommands = "";
			for (String command : commands) {
				if (command.contains("cfe") || command.contains("compiler-rt")) {
					continue;
				} else if (command.contains("sphinx")) {
					continue;
				} else if (command.contains("clang-analyzer")) {
					break;
				}
				finalCommands = finalCommands + command + "\n";
			}
			pack.getCommands().clear();
			pack.getCommands().add(new UserCommand(finalCommands, "root"));
		}
	}

}
