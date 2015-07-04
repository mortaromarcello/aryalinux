package org.aryalinux.parser.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.appdb.model.PackageEntity;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;
import org.aryalinux.parser.ui.blfs.BLFSParserUI;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class Util {
	public static String bookDirectory;
	public static String bootScriptsPath;
	public static String outputDirectory;
	public static BLFSParserUI blfsParserUI;
	public static boolean isSystemd;

	public static String readFile(String filePath) throws Exception {
		BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(new FileInputStream(filePath)));
		StringBuilder builder = new StringBuilder();
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			if (!line.endsWith("=")) {
				builder.append(line + "br3ak");
			} else {
				builder.append(line + "\n");
			}
		}
		bufferedReader.close();
		return builder.toString();
	}

	public static String readResource(String resource) throws Exception {
		InputStream inputStream = Util.class.getClassLoader()
				.getResourceAsStream(resource);
		byte[] data = new byte[inputStream.available()];
		inputStream.read(data);
		inputStream.close();
		return new String(data);
	}

	public static String readFileSimple(String filePath) throws Exception {
		BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(new FileInputStream(filePath)));
		StringBuilder builder = new StringBuilder();
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			builder.append(line + "\n");
		}
		bufferedReader.close();
		return builder.toString();
	}

	public static void writeFile(String filePath, String data) throws Exception {
		FileOutputStream fileOutputStream = new FileOutputStream(filePath);
		fileOutputStream.write(data.getBytes());
		fileOutputStream.close();
	}

	public static String reformat(String commands) {
		String formatted = commands;
		formatted = formatted.replace("&nbsp;", " ");
		formatted = formatted.replace("&amp;", "&");
		formatted = formatted.replace("&lt;", "<");
		formatted = formatted.replace("&gt;", ">");
		formatted = formatted.replace("&quot;", "\"");
		formatted = formatted.replace("br3ak", "\n");

		formatted = formatted.replace("<code class=\"literal\">", "");
		formatted = formatted.replace("</code>", "");

		return formatted;
	}

	public static String getDirectory(String tarball) {
		if (tarball != null && !tarball.contains("bootscripts")
				&& !tarball.contains("systemd-units")) {
			return "`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `";
		} else if (tarball != null
				&& (tarball.contains("bootscripts") || tarball
						.contains("systemd-units"))) {
			return "`tar -tf " + tarball + " | sed -e 's@/.*@@' | uniq `";
		} else {
			return null;
		}
	}

	public static String wrapServiceInstall(String installCommand)
			throws Exception {
		if (bootScriptsPath == null) {
			if (!isSystemd) {
				Document doc = Jsoup.parse(readFile(bookDirectory
						+ File.separator + "introduction" + File.separator
						+ "bootscripts.html"));
				bootScriptsPath = doc.select("div.sect1 ul.compact li p a")
						.first().attr("href");
			} else {
				Document doc = Jsoup.parse(readFile(bookDirectory
						+ File.separator + "introduction" + File.separator
						+ "systemd-units.html"));
				bootScriptsPath = doc.select("div.sect1 ul.compact li p a")
						.first().attr("href");
			}
		}
		String output = "\ncd $SOURCE_DIR\n" + "wget -nc " + bootScriptsPath
				+ "\n";
		String bootScriptsTarball = bootScriptsPath.substring(bootScriptsPath
				.lastIndexOf('/') + 1);
		output = output + "tar -xf " + bootScriptsTarball + "\n";
		String bootScriptsDir = Util.getDirectory(bootScriptsTarball);
		output = output + "cd " + bootScriptsDir + "\n";
		output = output + installCommand + "\n" + "cd ..\n" + "rm -rf "
				+ bootScriptsDir + "\n";
		return output;
	}

	public static void writePackageScript(BLFSPackage pack) throws Exception {
		FileOutputStream fileOutputStream = new FileOutputStream(new File(
				outputDirectory, pack.getName() + ".sh"));
		fileOutputStream.write(pack.toString().getBytes());
		fileOutputStream.close();
		if (blfsParserUI != null) {
			blfsParserUI.setStatus(pack.getName());
		}
		File f = new File(outputDirectory, pack.getName() + ".sh");
		f.setExecutable(true);
	}

	public static void delete(String filePath) {
		File file = new File(filePath);
		if (file.isDirectory()) {
			File[] contents = file.listFiles();
			for (File f : contents) {
				f.delete();
			}
		}

		file.delete();
	}

	public static String unify(List<UserCommand> commands) {
		String cmd = "";
		if (commands != null) {
			for (UserCommand command : commands) {
				cmd = cmd + command.getCommand() + "\n";
			}
			return cmd;
		} else {
			return "";
		}
	}

	public static List<UserCommand> divide(String command) {
		List<UserCommand> cmd = new ArrayList<UserCommand>();
		cmd.add(new UserCommand(command, "root"));
		return cmd;
	}
	
	public static PackageEntity toPackageEntity(BLFSPackage pack) {
		PackageEntity entity = new PackageEntity();
		entity.setName(pack.getName());
		entity.setBuildCommands(Util.unify(pack.getCommands()));
		entity.setDownloadUrls(pack.getDownloadUrls().toString());
		entity.setTarball(pack.getTarball());
		entity.setExtractionDirectory(pack.getDirectoryName());
		entity.setDependencies(pack.getDependencies().toString());
		return entity;
	}
}
