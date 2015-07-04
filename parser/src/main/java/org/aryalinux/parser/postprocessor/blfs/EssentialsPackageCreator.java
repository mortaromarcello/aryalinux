package org.aryalinux.parser.postprocessor.blfs;

import org.aryalinux.parser.blfs.MetaPackageBuilder;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;

public class EssentialsPackageCreator implements MetaPackageBuilder {
	public BLFSPackage createPackage() {
		BLFSPackage pack = new BLFSPackage();
		pack.setName("linux-essentials");
		pack.getDependencies().add("python");
		pack.getDependencies().add("doxygen");
		pack.getDependencies().add("wget");
		pack.getDependencies().add("sudo");
		pack.getDependencies().add("openssl");
		pack.getDependencies().add("linux-pam");
		pack.getDependencies().add("nano");
		pack.getDependencies().add("shadow");
		pack.getDependencies().add("usbutils");
		pack.getDependencies().add("pciutils");
		pack.getDependencies().add("parted");
		pack.getDependencies().add("gptfdisk");
		pack.getCommands().add(new UserCommand("echo \"Installing essentials.\"", "root"));
		return pack;
	}
}
