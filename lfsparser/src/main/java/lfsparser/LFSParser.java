package lfsparser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class LFSParser {
	public static void main(String[] args) throws Exception {
		String bookDir = "/home/chandrakant/Work/svn-20150928/book/20150928-systemd/";
		String wgetList = "/home/chandrakant/Work/svn-20150928/book/20150928-systemd/wget-list";
		String outputDir = "/home/chandrakant/Work/svn-20150928/scripts/";

		File file = new File(outputDir);
		file.mkdirs();

		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(wgetList)));
		List<String> tarballs = new ArrayList<String>();
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			if (!line.endsWith(".patch")) {
				tarballs.add(line.substring(line.lastIndexOf('/') + 1));
			}
		}
		bufferedReader.close();
		Document indexDoc = Jsoup.parse(Util.readFileSpecial(bookDir + File.separator + "index.html"));
		Elements pageLinks = indexDoc.select("li.sect1 a");
		for (Element link : pageLinks) {
			File dir = new File(outputDir + File.separator
					+ link.attr("href").substring(0, link.attr("href").lastIndexOf('/') + 1));
			dir.mkdirs();
			try {
				Parser parser = new Parser(bookDir + File.separator + link.attr("href"));
				String str = parser.generate();
				if (str != null) {
					FileOutputStream fout = new FileOutputStream(outputDir + File.separator
							+ (link.attr("href").replace("/", "/" + Util.getNextStepIndex() + "-"))
									.replace(".html", ".sh").replace("br3ak", ""));
					parser.parse(tarballs);
					String data = Util.removeEntities(str);
					fout.write(data.getBytes());
					fout.close();
				}
			} catch (Exception ex) {
				System.out.println(ex);
			}
		}
	}
}
