package blfsparser;

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
}
