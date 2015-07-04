package org.aryalinux.parser.utils;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

public class Eliminator {
	public static String eliminate(Map<String, String> replaceables,
			String subject) {
		replaceables = sortTheList(replaceables);
		for (Entry<String, String> entry : replaceables.entrySet()) {
			subject = subject.replace(entry.getKey(), entry.getValue());
		}
		return subject;
	}

	private static Map<String, String> sortTheList(
			Map<String, String> replaceables) {
		String[] keys = new String[replaceables.entrySet().size()];
		int count = 0;
		for (Entry<String, String> entry : replaceables.entrySet()) {
			keys[count++] = entry.getKey();
		}
		for (int i = 0; i < keys.length; i++) {
			for (int j = 0; j < keys.length; j++) {
				if (keys[i].length() > keys[j].length()) {
					String str = keys[i];
					keys[i] = keys[j];
					keys[j] = str;
				}
			}
		}
		LinkedHashMap<String, String> sorted = new LinkedHashMap<String, String>();
		for (String str : keys) {
			sorted.put(str, replaceables.get(str));
		}
		return sorted;
	}
}
