package blfsparser;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

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
		for(String str : extensions) {
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
		builder.append("\n");
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
}
