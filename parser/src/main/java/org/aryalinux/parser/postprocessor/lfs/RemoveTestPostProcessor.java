package org.aryalinux.parser.postprocessor.lfs;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map.Entry;
import java.util.StringTokenizer;

import org.aryalinux.parser.commons.lfs.LFSPostProcessor;
import org.aryalinux.parser.commons.lfs.Step;

public class RemoveTestPostProcessor implements LFSPostProcessor {
	LinkedHashMap<String, String> commandsToBeReplaced;

	public RemoveTestPostProcessor() {
		commandsToBeReplaced = new LinkedHashMap<String, String>();
		BufferedReader bufferedReader = null;
		try {
			bufferedReader = new BufferedReader(new InputStreamReader(
					getClass().getClassLoader().getResourceAsStream(
							"lfsreplaceables.properties")));
			String line = null;
			while ((line = bufferedReader.readLine()) != null) {
				StringTokenizer tokens = new StringTokenizer(line, "?");
				if (tokens.countTokens() == 1) {
					commandsToBeReplaced.put(tokens.nextToken(), "");
				} else if (tokens.countTokens() == 2) {
					commandsToBeReplaced.put(tokens.nextToken(),
							tokens.nextToken());
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		sortTheList();
	}

	public void process(Step step) {
		String commands = step.getCommands();
		for (Entry<String, String> entry : commandsToBeReplaced.entrySet()) {
			if (entry.getValue() == null) {
				entry.setValue("");
			}
			commands = commands.replace(entry.getKey().toString(), entry
					.getValue().toString());
		}
		step.setCommands(commands);
	}

	private void sortTheList() {
		String[] keys = new String[commandsToBeReplaced.entrySet().size()];
		int count = 0;
		for (Entry<String, String> entry : commandsToBeReplaced.entrySet()) {
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
			sorted.put(str, commandsToBeReplaced.get(str));
		}
		this.commandsToBeReplaced = sorted;
	}
}
