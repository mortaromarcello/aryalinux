package lfsparser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class LFSParser {
	private static List<String> fileNames;
	
	static {
		fileNames = new ArrayList<String>();
		fileNames.add("1.sh");
		fileNames.add("2.sh");
		fileNames.add("3.sh");
		fileNames.add("4.sh");
		fileNames.add("5.sh");
		fileNames.add("strip.sh");
		fileNames.add("postlfs/01-which.sh");
		fileNames.add("postlfs/02-lsb-release.sh");
		fileNames.add("postlfs/03-os-prober.sh");
		fileNames.add("postlfs/04-busybox.sh");
		fileNames.add("postlfs/05-bootloader.sh");
		fileNames.add("postlfs/06-openssl.sh");
		fileNames.add("postlfs/07-wget.sh");
		fileNames.add("postlfs/08-sudo.sh");
		fileNames.add("postlfs/09-python.sh");
		fileNames.add("postlfs/10-alps.sh");
		fileNames.add("postlfs/11-profile.sh");
	}
	
	private static void writeFile(byte[] data, String dest) throws Exception {
		FileOutputStream fileOutputStream = new FileOutputStream(dest);
		fileOutputStream.write(data);
		fileOutputStream.close();
	}
	
	private static void generateAdditionalScripts(String outputDir) throws Exception {
		File f1 = new File(outputDir + File.separator + "postlfs");
		f1.mkdirs();
		for (String fileName: fileNames) {
			InputStream inputStream = LFSParser.class.getClassLoader().getResourceAsStream("scripts" + File.separator + fileName);
			byte[] data = new byte[inputStream.available()];
			inputStream.read(data);
			writeFile(data, outputDir + File.separator + fileName);
		}
	}
	
	public static void main(String[] args) throws Exception {
		String bookDir = "/home/chandrakant/Work/svn-20150928/book/20150928-systemd/";
		String wgetList = "/home/chandrakant/Work/svn-20150928/book/20150928-systemd/wget-list";
		String outputDir = "/home/chandrakant/Desktop/lfs-generated/";

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
				parser.parse(tarballs);
				String str = parser.generate();
				if (str != null) {
					FileOutputStream fout = new FileOutputStream(outputDir + File.separator
							+ (link.attr("href").replace("/", "/" + Util.getNextStepIndex() + "-"))
									.replace(".html", ".sh").replace("br3ak", ""));
					String data = Util.removeEntities(str);
					data = RulesEngine.applyRules(data);
					fout.write(data.getBytes());
					fout.close();
				}
			} catch (Exception ex) {
				System.out.println(ex);
				//ex.printStackTrace(System.out);
				//System.exit(0);
			}
		}
		generateAdditionalScripts(outputDir);
	}
}
