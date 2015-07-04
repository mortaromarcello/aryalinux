package org.aryalinux.parser.blfs;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.utils.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class PerlModulesParser {
	public static String perlModulesPage;
	public static String outputDirectory;
	public static ArrayList<BLFSPackage> packages = new ArrayList<BLFSPackage>();

	public static void parse() throws Exception {
		Document doc = Jsoup.parse(Util.readFileSimple(perlModulesPage));
		Elements elements = doc.select("div.package").first().children();
		String name = null;
		BLFSPackage pack = null;
		for (Element e : elements) {
			if (e.tagName().equals("h3")) {
				name = e.select("a").attr("id");
			}
			if (e.tagName().equals("div")
					&& e.attr("class").equals("itemizedlist")) {
				pack = getPackage(e);
			}
			if (name != null && pack != null) {
				packages.add(pack);
			}
		}
	}

	public static BLFSPackage getPackage(Element element) {
		BLFSPackage pack = null;
		Element ownLiteralLayout = element.select("div.literallayout").first();
		if (ownLiteralLayout != null) {
			pack = new BLFSPackage();
			String url = ownLiteralLayout.select("p").html();
			pack.getDownloadUrls().add(url);
			if (ownLiteralLayout != null) {
				Elements siblingsOfOwnLiteralLayout = ownLiteralLayout
						.siblingElements();
				for (Element siblingOfOwnLiteralLayout : siblingsOfOwnLiteralLayout) {
					if (siblingOfOwnLiteralLayout.tagName().equals("div")
							&& siblingOfOwnLiteralLayout.attr("class").equals(
									"itemizedlist")) {
						BLFSPackage p = getPackage(siblingOfOwnLiteralLayout);
						packages.add(p);
						if (p != null) {
							pack.getDependencies().add(p.getName());
						}
					}
				}
			}
		}
		return pack;
	}

	public static void main(String[] args) throws Exception {
		PerlModulesParser.perlModulesPage = "D:/Experiments/lfs-books/blfs/www.linuxfromscratch.org/blfs/view/stable/general/perl-modules.html";
		PerlModulesParser.parse();
	}
}
