package org.aryalinux.parser.utils;

public class LineExtractor {
	public static String extract(String subject, String from, String to) {
		String[] lines = subject.split("\n");
		String output = "";
		boolean extract = false;
		for (String line : lines) {
			if (line.trim().equals(from)) {
				extract = true;
			}
			if (extract) {
				output = output + line + "\n";
			}
			if (extract && line.trim().equals(to)) {
				extract = false;
				break;
			}
		}
		return output;
	}
}
