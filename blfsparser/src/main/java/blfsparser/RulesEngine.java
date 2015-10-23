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
				if (command.startsWith("USER_INPUT") && command.contains(".texi") && !command.contains("./configure")) {
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
		if (parser.getRecommendedDependencies().contains("x_xorg7.html#xorg-env")) {
			parser.getRecommendedDependencies().remove("x_xorg7.html#xorg-env");
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() +
			// "_" + parser.getName());
		}
		if (parser.getOptionalDependencies().contains("x_xorg7.html#xorg-env")) {
			parser.getOptionalDependencies().remove("x_xorg7.html#xorg-env");
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() +
			// "_" + parser.getName());
		}
		// if (parser.getRequiredDependencies().contains("#xorg-env"))
	}

	private static void xorgPrefixRule(Parser parser) {
		List<String> commands = parser.getCommands();
		boolean declareVariable = false;
		for (String command : commands) {
			if (command.contains("XORG_PREFIX") || command.contains("XORG_CONFIG")) {
				declareVariable = true;
			}
		}
		if (declareVariable && !parser.getCommands().get(0).contains("USER_INPUT:export XORG_PREFIX")) {
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
		}
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
		if (parser.getName().endsWith("systemd")) {
			List<String> downloadUrls = parser.getDownloadUrls();
			for (String str : BLFSParser.systemdDownloads) {
				downloadUrls.add(str);
			}
			Util.replaceCommandContaining(parser, "systemd", "-compat-1.patch", "-compat-3.patch");
		}
	}

	private static void kdePrefix(Parser parser) {
		boolean addDeclaration = false;
		for (String command : parser.getCommands()) {
			if (command.contains("$KDE_PREFIX")) {
				addDeclaration = true;
			}
		}
		if (addDeclaration) {
			parser.getCommands().add(0, "USER_INPUT:export KDE_PREFIX=/opt/kde\n");
		}
	}

	private static void qt4Prefix(Parser parser) {
		// TODO: Prefix all QT Variables to all command snippets...
		if (parser.getName().equals("qt4") || parser.getName().equals("qca") || parser.getName().equals("vlc")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (command.startsWith("ROOT_COMMANDS:")) {
					newCommands
							.add("ROOT_COMMANDS:export QT4PREFIX=\"/opt/qt4\"\nexport QT4BINDIR=\"$QT4PREFIX/bin\"\nexport QT4DIR=\"$QT4PREFIX\"\nexport QTDIR=\"$QT4PREFIX\"\nexport PATH=\"$PATH:$QT4BINDIR\"\nexport PKG_CONFIG_PATH=\"/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig\"\n"
									+ command);
				} else {
					newCommands
							.add("USER_INPUT:export QT4PREFIX=\"/opt/qt4\"\nexport QT4BINDIR=\"$QT4PREFIX/bin\"\nexport QT4DIR=\"$QT4PREFIX\"\nexport QTDIR=\"$QT4PREFIX\"\nexport PATH=\"$PATH:$QT4BINDIR\"\nexport PKG_CONFIG_PATH=\"/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig\"\n"
									+ command);
				}
				parser.setCommands(newCommands);
			}
		}
	}

	private static void qt4(Parser parser) {
		if (parser.getName().contains("qt4")) {
			String misplaced = null;
			String toBeDeleted = null;
			for (String command : parser.getCommands()) {
				if (command.contains("mkdir /opt/qt-")) {
					misplaced = command;
				}
				if (command.contains("-bindir") && command.contains("/usr/bin/qt4") && command.contains("\\")) {
					toBeDeleted = command;
				}
			}
			if (misplaced != null) {
				parser.getCommands().remove(misplaced);
				parser.getCommands().add(misplaced);
			}
			if (toBeDeleted != null) {
				parser.getCommands().remove(toBeDeleted);
			}
		}
	}

	private static void dbus(Parser parser) {
		if (parser.getName().equals("dbus")) {
			parser.getDownloadUrls().add(BLFSParser.dbusLink);
			List<String> commands = parser.getCommands();
			int index = -1;
			String oldCommand = null;
			for (int i = 0; i < commands.size(); i++) {
				String command = commands.get(i);
				if (command.contains("mv -v /usr/lib/libdbus-1.so.*")) {
					index = i;
					oldCommand = command;
				}
			}
			if (index != -1 && oldCommand != null) {
				commands.set(index, oldCommand.replace("USER_INPUT", "ROOT_COMMANDS"));
			}
		}
	}

	private static void libvpx(Parser parser) {
		if (parser.getName().equals("libvpx")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (command.contains("../libvpx-v1.4.0/configure")) {
					command = command.replace("../libvpx-v1.4.0/configure", "../$DIRECTORY/configure");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void akonadi(Parser parser) {
		if (parser.getName().equals("akonadi")) {
			parser.getRequiredDependencies().remove("server_mariadb.html");
			parser.getRequiredDependencies().remove("server_postgresql.html");
		}
	}

	private static void kdelibs(Parser parser) {
		if (parser.getName().equals("kdelibs")) {
			parser.getRecommendedDependencies().remove("general_udisks.html");
		}
	}

	private static void wget(Parser parser) {
	}

	private static void openssh(Parser parser) {
		if (parser.getName().equals("openssh")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (!command.startsWith("USER_INPUT:ssh-keygen")) {
					newCommands.add(command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void freetype(Parser parser) {
		if (parser.getName().equals("freetype2")) {
			// System.out.println(parser.getCommands());
		}
	}

	private static void llvm(Parser parser) {
		if (parser.getName().equals("llvm")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (!command.contains("sphinx")
						&& !command.contains("install -v -m644 docs/_build/man/* /usr/share/man/man1/")) {
					newCommands.add(command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void unzip(Parser parser) {
		Util.removeCommandContaining(parser, "unzip", "/path/to/unzipped/files");
	}

	private static void qca(Parser parser) {
		Util.replaceCommandContaining(parser, "qca", "${QT4DIR}/include/qt4/", "${QT4DIR}/include/");
		Util.replaceCommandContaining(parser, "qca", "${QT4DIR}/share/qt4/mkspecs/features/",
				"${QT4DIR}/mkspecs/features/");
	}

	private static void libassuan(Parser parser) {
		if (parser.getName().equals("libassuan")) {
			Util.removeCommandContaining(parser, "libassuan", "make -C doc pdf ps");
			Util.removeCommandContaining(parser, "libassuan", "install -v -dm755 /usr/share/doc/libassuan-2.2.1");
		}
	}

	private static void openldap(Parser parser) {
		if (parser.getName().equals("openldap")) {
			parser.getCommands().add(2,
					"USER_INPUT:cd $SOURCE_DIR\nsudo rm -rf $DIRECTORY\ntar xf $TARBALL\ncd $DIRECTORY\n");
			Util.removeCommandContaining(parser, "openldap", "systemctl start slapd");
			Util.removeCommandContaining(parser, "openldap", "ldapsearch -x -b");
		}
	}/*
		 * 
		 * private static void x7driver(Parser parser) { if
		 * (parser.getName().equals("x7driver")) { parser.getCommands().add(0,
		 * "USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\""
		 * ); } }
		 */

	private static void gnomeSettingsDaemon(Parser parser) {
		if (parser.getName().equals("gnome-settings-daemon")) {
			parser.getRequiredDependencies().remove("x_x7driver.html#xorg-wacom-driver");
		}
	}

	private static void gnupg(Parser parser) {
		if (parser.getName().equals("gnupg")) {
			parser.getRequiredDependencies().add("general_npth.html");
			Util.removeCommandContaining(parser, "gnupg", "make -C doc pdf ps html");
			Util.removeCommandContaining(parser, "gnupg", "install -v -m644 doc/gnupg.html/*");
		}
	}

	private static void aspell(Parser parser) {
		if (parser.getName().equals("aspell")) {
			parser.getCommands().remove(parser.getCommands().size() - 1);
			parser.getCommands().remove(parser.getCommands().size() - 1);
		}
	}

	private static void popt(Parser parser) {
		if (parser.getName().equals("popt")) {
			Util.removeCommandContaining(parser, "popt", "/usr/share/doc/popt");
		}
	}

	private static void dhcpcd(Parser parser) {
		Util.removeCommandContaining(parser, "dhcpcd", "systemctl enable");
		Util.removeCommandContaining(parser, "dhcpcd", "systemctl start");
	}

	private static void networkManager(Parser parser) {
		if (parser.getName().equals("networkmanager")) {
			parser.getRecommendedDependencies().remove("basicnet_dhcp.html");
		}
	}

	private static void x7lib(Parser parser) {
		Util.removeCommandContaining(parser, "x7lib", "ln -sv $XORG_PREFIX/lib/X11");
	}

	private static void freetypeHarfbuzzCircularDeps(Parser parser) {
		if (parser.getName().equals("freetype2")) {
			parser.getRecommendedDependencies().remove("general_freetype2.html");
		}
		if (parser.getName().equals("harfbuzz")) {
			parser.getRecommendedDependencies().remove("general_freetype2.html");
			parser.getRecommendedDependencies().remove("general_harfbuzz.html");
			parser.getRecommendedDependencies().add("general_freetype2-without-harfbuzz.html");
		}
		if (parser.getName().equals("freetype2-without-harfbuzz")) {
			parser.getRecommendedDependencies().remove("general_freetype2.html");
			parser.getRecommendedDependencies().remove("general_harfbuzz.html");
		}
	}

	private static void xfce4session(Parser parser) {
		Util.replaceCommandContaining(parser, "xfce4-session", "update-mime-database",
				"update-mime-database /usr/share/mime");
	}
	
	private static void libisoburn(Parser parser) {
		Util.removeCommandContaining(parser, "libisoburn", "doxygen");
		Util.removeCommandContaining(parser, "libisoburn", "/usr/share/doc/libisoburn");
	}

	private static void libnotify(Parser parser) {
		if (parser.getName().equals("libnotify")) {
			parser.getRequiredDependencies().remove("xfce_xfce4-notifyd.html");
		}
	}

	private static void docbookXsl(Parser parser) {
		Util.removeCommandContaining(parser, "docbook-xsl", "em class=");
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
		xorgPrefixRule(parser);
		kdePrefix(parser);
		qt4(parser);
		dbus(parser);
		libvpx(parser);
		akonadi(parser);
		qt4Prefix(parser);
		kdelibs(parser);
		wget(parser);
		openssh(parser);
		freetype(parser);
		llvm(parser);
		unzip(parser);
		qca(parser);
		kdelibs(parser);
		libassuan(parser);
		openldap(parser);
		// x7driver(parser);
		gnomeSettingsDaemon(parser);
		gnupg(parser);
		aspell(parser);
		dhcpcd(parser);
		networkManager(parser);
		popt(parser);
		x7lib(parser);
		freetypeHarfbuzzCircularDeps(parser);
		xfce4session(parser);
		libnotify(parser);
		docbookXsl(parser);
		libisoburn(parser);
	}
}
