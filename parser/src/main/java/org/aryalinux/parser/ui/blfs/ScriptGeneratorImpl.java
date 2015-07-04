package org.aryalinux.parser.ui.blfs;

import java.io.File;
import java.io.FileOutputStream;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.utils.Util;

public class ScriptGeneratorImpl implements ScriptGenerator {
	private String template;
	private File outputDirectory;

	public void generate(BLFSPackage blfsPackage) throws Exception {
		String dependencies = "", downloads = "", unarchive = "", commands = "", directoryName = "", tarball = "";
		String name = blfsPackage.getName();
		String randomString = "" + System.currentTimeMillis();
		name = name.substring(name.lastIndexOf("/") + 1);

		if (blfsPackage.getDirectoryName() != null) {
			directoryName = blfsPackage.getDirectoryName();
		}

		for (String str : blfsPackage.getDependencies()) {
			str = str.substring(str.lastIndexOf('/') + 1);
			str = str.replace(".html", "");
			dependencies += ("#DEP:" + str + "\n");
		}
		if (blfsPackage.getDownloadUrls().size() > 0) {
			for (String str : blfsPackage.getDownloadUrls()) {
				downloads += ("wget -nc " + str + "\n");
			}
		}
		if (blfsPackage.getTarball() != null) {
			tarball = blfsPackage.getTarball();
			if (blfsPackage.getTarball().endsWith(".zip")) {
				String randomDir = "" + randomString;
				unarchive += ("mkdir -pv " + randomDir + "\n");
				unarchive += ("chmod -R a+rw " + randomDir + "\n");
				unarchive += ("cp " + blfsPackage.getTarball() + " "
						+ randomDir + "\n");
				unarchive += ("cd " + randomDir + "\n");
				unarchive += ("unzip $TARBALL\n");
			} else {
				unarchive += "tar -xf $TARBALL\n";
			}
		}
		if (blfsPackage.getCommands().size() > 0) {
			for (UserCommand command : blfsPackage.getCommands()) {
				if (command.getExecutedBy().equals("root")) {
					if (command.getCommand().contains("\"EOF\"")) {
						commands += ("cat > " + randomString + ".sh << \"ENDOFFILE\"\n");
					} else {
						commands += ("cat > " + randomString + ".sh << \"ENDOFFILE\"\n");
					}
					if (command.getCommand().trim().startsWith("make install-")) {
						commands += "wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2\n";
						commands += "tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .\n";
						commands += "cd blfs-systemd-units-20150210\n";
						commands += command.getCommand() + "\n";
						commands += "cd ..";

					} else {
						commands += command.getCommand();
					}
					commands += "\nENDOFFILE\n";
					commands += ("chmod a+x " + randomString + ".sh\n");
					commands += ("sudo ./" + randomString + ".sh\n");
					commands += ("sudo rm -rf " + randomString + ".sh\n\n");
				} else {
					commands += command.getCommand();
					commands += "\n\n";
				}
			}
		}

		String templateCopy = "" + template;
		templateCopy = templateCopy.replace("#DEPS", dependencies);
		templateCopy = templateCopy.replace("#TARBALL", tarball);
		if (tarball.equals("")) {
			templateCopy = templateCopy.replace("cd \n", "");
		}
		templateCopy = templateCopy.replace("#DOWNLOADS", downloads);
		templateCopy = templateCopy.replace("#UNARCHIVE", unarchive);
		templateCopy = templateCopy.replace("#COMMANDS", commands);
		templateCopy = templateCopy.replace("#DIRECTORY", directoryName);
		templateCopy = templateCopy.replace("#NAME", name);

		templateCopy = templateCopy.replace("TARBALL=\n", "");
		templateCopy = templateCopy.replace("DIRECTORY=\n", "");
		if (directoryName.equals("") || tarball.endsWith(".zip")) {
			templateCopy = templateCopy.replace("cd $DIRECTORY\n", "");
			templateCopy = templateCopy.replace("sudo rm -rf $DIRECTORY\n", "");
		}

		name = name + ".sh";
		File script = new File(outputDirectory, name);
		FileOutputStream fileOutputStream = new FileOutputStream(script);
		fileOutputStream.write(templateCopy.getBytes());
		fileOutputStream.close();
		script.setExecutable(true);
	}

	public void setTemplate(String templatefile) throws Exception {
		template = Util.readResource(templatefile);
	}

	public void setDestination(String destinationDirectory) throws Exception {
		outputDirectory = new File(destinationDirectory);
		outputDirectory.mkdirs();
	}

}
