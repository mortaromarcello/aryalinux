package blfsparser;

import java.util.ArrayList;
import java.util.List;

import ch.qos.logback.core.net.SyslogOutputStream;

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

	public static void removeDoxygenCommands(Parser parser) {
		if (parser.getOptionalDependencies().contains("general_doxygen.html")) {
			List<String> newCommands = new ArrayList<String>();
			boolean docBuild = false;
			for (String command : parser.getCommands()) {
				boolean shouldAdd = true;
				if (command.startsWith("USER_INPUT") && (command.contains("USER_INPUT:doxygen") || command.contains("USER_INPUT:make doc") || (command.startsWith("USER_INPUT:make") && command.endsWith("doxygen")))) {
					docBuild = true;
					shouldAdd = false;
				}
				if (command.startsWith("ROOT_COMMANDS") && command.contains("/usr/share/doc") && !(command.trim().startsWith("ROOT_COMMANDS:make") && command.trim().endsWith("install")) && !command.contains("make install")) {
					shouldAdd = false;
				}
				if (shouldAdd) {
					newCommands.add(command);
				}
				else {
					//System.out.println(parser.getSubSection() + "_" + parser.getName() + " : " + command);
				}
			}
			parser.setCommands(newCommands);
		}
	}
	
	private static void xorgEnvRule(Parser parser) {
		if (parser.getRequiredDependencies().contains("x_xorg7.html#xorg-env")) {
			parser.getRequiredDependencies().remove("x_xorg7.html#xorg-env");
			parser.getCommands().add(0, "USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() + "_" + parser.getName());
		}
		//if (parser.getRequiredDependencies().contains("#xorg-env"))
	}

	public static void applyRules(Parser parser) {
		x7Rules(parser);
		removeDoxygenCommands(parser);
		xorgEnvRule(parser);
	}
}
