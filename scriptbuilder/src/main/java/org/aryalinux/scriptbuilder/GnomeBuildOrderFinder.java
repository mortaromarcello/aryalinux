package org.aryalinux.scriptbuilder;

import java.net.URL;
import java.util.ArrayList;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class GnomeBuildOrderFinder {
	public static void main(String[] args) throws Exception {
		Document document = Jsoup
				.parse(new URL(
						"http://www.linuxfromscratch.org/blfs/view/stable-systemd/gnome/buildorder.html"),
						10000);
		Elements links = document.select("div.sect1 div.itemizedlist ul li p a");
		ArrayList<String> list = new ArrayList<String>();
		for (Element element : links) {
			list.add(element.attr("href").substring(element.attr("href").lastIndexOf('/') + 1).replace(".html", ""));
			System.out.print(element.attr("href").substring(element.attr("href").lastIndexOf('/') + 1).replace(".html", ""));
			System.out.print(" ");
		}
	}
}
