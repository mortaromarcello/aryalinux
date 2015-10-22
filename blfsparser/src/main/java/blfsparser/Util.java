package blfsparser;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Util {
	private static List<String> extensions = new ArrayList<String>();

	static {
		extensions.add(".tar.gz");
		extensions.add(".tar.bz2");
		extensions.add(".tar.xz");
		extensions.add(".lzma");
		extensions.add(".tar");
		extensions.add(".tgz");
		extensions.add(".zip");
		extensions.add(".patch");
	}

	public static boolean isValidTarballDownloadUrl(String url) {
		for (String str : extensions) {
			if (url.endsWith(str)) {
				return true;
			}
		}
		return false;
	}

	public static String readFileEncode(String filePath) throws Exception {
		FileInputStream inputStream = new FileInputStream(filePath);
		byte[] data = new byte[inputStream.available()];
		inputStream.read(data);
		String str = new String(data);
		str = str.replace("\n", "br3ak");
		str = str.replace("=br3ak", "=\n");
		inputStream.close();
		return str;
	}

	public static String wrapRootCommands(String rawCommands) {
		StringBuilder builder = new StringBuilder();
		builder.append("\n");
		builder.append("sudo tee rootscript.sh << \"ENDOFROOTSCRIPT\"\n");
		builder.append(rawCommands + "\n");
		builder.append("ENDOFROOTSCRIPT\n");
		builder.append("sudo chmod 755 rootscript.sh\n");
		builder.append("sudo ./rootscript.sh\n");
		builder.append("sudo rm rootscript.sh\n");
		return builder.toString();
	}

	public static String removeEntities(String rawString) {
		rawString = rawString.replace("&amp;", "&");
		rawString = rawString.replace("&lt;", "<");
		rawString = rawString.replace("&gt;", ">");
		rawString = rawString.replace("&quot;", "\"");
		rawString = rawString.replace("&nbsp;", " ");
		rawString = rawString.replace("<code class=\"literal\">", "").replace("</code>", "");
		return rawString;
	}

	public static void removeCommandContaining(Parser parser, String name, String needle) {
		if (parser.getName().equals(name)) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (!command.contains(needle)) {
					newCommands.add(command);
				} else {
					// System.out.println(name + ":" + command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	public static void replaceCommandContaining(Parser parser, String name, String needle, String replacement) {
		if (parser.getName().equals(name)) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (command.contains(needle)) {
					newCommands.add(command.replace(needle, replacement));
				} else {
					newCommands.add(command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	public static Set<String> createSet(String... elements) {
		Set<String> deps = new LinkedHashSet<String>();
		for (String element : elements) {
			deps.add(element);
		}
		return deps;
	}

	public static List<String> createList(String... elements) {
		List<String> deps = new LinkedList<String>();
		for (String element : elements) {
			deps.add(element);
		}
		return deps;
	}

	public static Elements selectClass(Element parent, String className) {
		Elements children = parent.children();
		Elements selected = new Elements();
		for (Element child : children) {
			if (child.attr("class").equals(className)) {
				selected.add(child);
			}
		}
		return selected;
	}

	public static Element getNextSiblingByClass(Element here, String clazz) {
		while (!here.nextElementSibling().attr("class").equals(clazz)) {
			here = here.nextElementSibling();
		}
		if (here.nextElementSibling().attr("class").equals(clazz)) {
			return here.nextElementSibling();
		} else {
			return null;
		}
	}

	public static Element getNextChildByClass(Element parent, String clazz) {
		Elements children = parent.children();
		for (Element child : children) {
			if (child.attr("href").equals(clazz)) {
				return child;
			}
		}
		return null;
	}

	public static Element getNextRecursiveChildByClass(Element parent, String clazz) {
		Elements children = parent.children();
		for (Element child : children) {
			if (child.attr("class").equals(clazz)) {
				return child;
			}
			else {
				Element found = getNextRecursiveChildByClass(child, clazz);
				if (found != null) {
					return found;
				}
			}
		}
		return null;
	}
}
