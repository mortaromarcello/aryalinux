package blfsparser;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class BLFSParser {
	private static String parent;
	private static String outputDir;
	public static String systemdUnits = null;
	public static String systemdUnitsTarball = null;
	public static List<String> systemdDownloads = new ArrayList<String>();
	
	static {
		systemdDownloads.add("http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-224.tar.xz");
		//systemdDownloads.add("http://www.linuxfromscratch.org/patches/downloads/systemd/systemd-224-compat-3.patch");
		systemdDownloads.add("http://www.linuxfromscratch.org/patches/downloads/systemd/systemd-224-compat-1.patch");
	}
	public static void main(String[] args) throws Exception {
		String indexPath = "/home/chandrakant/blfs-svn/index.html";
		String outDir = "/home/chandrakant/blfs-generated";
		
		Document document = Jsoup.parse(new File(indexPath), "utf8");
		parent = indexPath.substring(0, indexPath.lastIndexOf('/'));
		outputDir = outDir;
		Elements pageLinks = document.select("li.sect1 a");
		for (Element pageLink : pageLinks) {
			String href = pageLink.attr("href");
			String name = href.substring(href.lastIndexOf('/') + 1).replace(".html", "");
			String subDir = href.substring(0, href.lastIndexOf('/'));
			// new File(outputDir + File.separator + subDir).mkdirs();
			String sourceFile = parent + File.separator + href;
			Parser parser = null;
			if (href.contains("x7driver")) {
				parser = new XorgDriverParser(name, sourceFile, subDir);
			}
			else {
				parser = new Parser(name, sourceFile, subDir);
			}
			parser.parse();
			RulesEngine.applyRules(parser);
			String generated = parser.generate();
			if (pageLink.attr("href").contains("systemd-units")) {
				systemdUnits = parser.getDownloadUrls().get(0);
				systemdUnitsTarball = systemdUnits.substring(systemdUnits.lastIndexOf('/') + 1);
				continue;
			}
			if (generated != null) {
				FileOutputStream output = new FileOutputStream(outputDir + File.separator + href.replace("/", "_").replace(".html", ".sh"));
				output.write(generated.getBytes());
				output.close();
			}
			else {
				//System.out.println(parser.getName() + " gave null");
			}
		}
	}
}
