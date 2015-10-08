package blfsparser;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class RulesEngine {
	private static void x7Rules(Parser parser) {
		if (parser.getName().startsWith("x7")) {
			List<String> commands = parser.getCommands();
			List<String> newCommands = new ArrayList<String>();
			for (String command : commands) {
				if (command.contains("mkdir app")) {
					command = command.replace("mkdir app", "mkdir -pv app");
				} else if (command.contains("mkdir lib")) {
					command = command.replace("mkdir lib", "mkdir -pv lib");
				} else if (command.contains("mkdir font")) {
					command = command.replace("mkdir font", "mkdir -pv font");
				} else if (command.contains("mkdir proto")) {
					command = command.replace("mkdir proto", "mkdir -pv proto");
				}
				if (command.contains("bash -e")) {
					command = command.replace("bash -e", "");
				}
				if (command.contains("exit")) {
					command = command.replace("exit", "");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void removeDoxygenCommands(Parser parser) {
		if (parser.getOptionalDependencies().contains("general_doxygen.html")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				boolean shouldAdd = true;
				if (command.startsWith("USER_INPUT")
						&& (command.contains("USER_INPUT:doxygen") || command.contains("USER_INPUT:make doc")
								|| (command.startsWith("USER_INPUT:make") && command.endsWith("doxygen")))) {
					shouldAdd = false;
				}
				if (command.startsWith("ROOT_COMMANDS") && command.contains("/usr/share/doc")
						&& !(command.trim().startsWith("ROOT_COMMANDS:make") && command.trim().endsWith("install"))
						&& !command.contains("make install")) {
					shouldAdd = false;
				}
				if (shouldAdd) {
					newCommands.add(command);
				} else {
					// System.out.println(parser.getSubSection() + "_" +
					// parser.getName() + " : " + command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void removeTexliveCommands(Parser parser) {
		if (parser.getOptionalDependencies().contains("pst_texlive.html")) {
			List<String> newCommands = new ArrayList<String>();
			boolean texiCommands = false;
			for (String command : parser.getCommands()) {
				boolean shouldAdd = true;
				if (command.startsWith("USER_INPUT") && command.contains(".texi")) {
					shouldAdd = false;
					texiCommands = true;
				}
				if (command.startsWith("ROOT_COMMANDS") && command.contains("/usr/share/doc")
						&& !(command.trim().startsWith("ROOT_COMMANDS:make") && command.trim().endsWith("install"))
						&& !command.contains("make install") && texiCommands) {
					shouldAdd = false;
				}
				if (shouldAdd) {
					newCommands.add(command);
				} else {
					// System.out.println(parser.getSubSection() + "_" +
					// parser.getName() + " : " + command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void xorgEnvRule(Parser parser) {
		if (parser.getRequiredDependencies().contains("x_xorg7.html#xorg-env")) {
			parser.getRequiredDependencies().remove("x_xorg7.html#xorg-env");
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() +
			// "_" + parser.getName());
		}
		// if (parser.getRequiredDependencies().contains("#xorg-env"))
	}

	private static void makeMultiple(Parser parser) {
		List<String> newCommands = new ArrayList<String>();
		for (String command : parser.getCommands()) {
			command = command.replace("br3ak", "\n");
			String newCommand = "";
			StringTokenizer st = new StringTokenizer(command, "\n");
			while (st.hasMoreTokens()) {
				String str = st.nextToken();
				String trimmed = str.trim();
				/*
				 * if (parser.getName().contains("lynx")) {
				 * System.out.println("[" + trimmed + "]"); }
				 */
				if (trimmed.equals("make")) {
					newCommand = newCommand + str.replace("make", "make \"-j`nproc`\"") + "\n";
				} else {
					newCommand = newCommand + str + '\n';
				}
			}
			newCommands.add(newCommand);
		}
		parser.setCommands(newCommands);
	}

	private static void libgpgError(Parser parser) {
		List<String> newCommands = new ArrayList<String>();
		if (parser.getName().contains("libgpg-error")) {
			for (String command : parser.getCommands()) {
				if (command.contains("mv -v /usr/lib/libgpg-error.so.*")) {
					command = command.replace("USER_INPUT:", "ROOT_COMMANDS:");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void libgpgcrypt(Parser parser) {
		List<String> newCommands = new ArrayList<String>();
		if (parser.getName().contains("libgcrypt")) {
			for (String command : parser.getCommands()) {
				if (command.contains("mv -v /usr/lib/libgcrypt.so.*")) {
					command = command.replace("USER_INPUT:", "ROOT_COMMANDS:");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void systemd(Parser parser) {
		if(parser.getName().endsWith("systemd")) {
			List<String> downloadUrls = parser.getDownloadUrls();
			for (String str : BLFSParser.systemdDownloads) {
				downloadUrls.add(str);
			}
		}
	}
	public static void applyRules(Parser parser) {
		x7Rules(parser);
		removeDoxygenCommands(parser);
		xorgEnvRule(parser);
		makeMultiple(parser);
		libgpgError(parser);
		libgpgcrypt(parser);
		removeTexliveCommands(parser);
		systemd(parser);
	}
}
