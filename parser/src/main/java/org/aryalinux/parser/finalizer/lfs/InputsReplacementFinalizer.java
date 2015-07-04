package org.aryalinux.parser.finalizer.lfs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map.Entry;

import org.aryalinux.parser.commons.lfs.Finalizer;
import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.utils.Util;

public class InputsReplacementFinalizer implements Finalizer {
	private String inputsStr = "";

	public InputsReplacementFinalizer() throws Exception {
		BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(getClass().getClassLoader()
						.getResourceAsStream("inputs.properties")));
		String line = null;
		LinkedHashMap<String, String> properties = new LinkedHashMap<String, String>();
		while ((line = bufferedReader.readLine()) != null) {
			String[] parts = line.split(":");
			properties.put(parts[0], parts[1]);
		}
		for (Entry<String, String> entry : properties.entrySet()) {
			inputsStr = inputsStr + "read -p \"" + entry.getValue() + "\" "
					+ entry.getKey() + "\n";
		}
		inputsStr = inputsStr + "\n";
		inputsStr = inputsStr + "if [ \"x$LOCALE\" == \"x\" ]; then LOCALE=\"en_IN.utf-8\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$OS_PRETTY_NAME\" == \"x\" ]; then OS_PRETTY_NAME=\"AryaLinux\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$OS_VERSION\" == \"x\" ]; then OS_VERSION=\"1.0\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$OS_CODENAME\" == \"x\" ]; then OS_CODENAME=\"A15\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$HOST_NAME\" == \"x\" ]; then HOST_NAME=\"aryalinux\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$DOMAIN_NAME\" == \"x\" ]; then DOMAIN_NAME=\"aryalinux.org\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$PRIMARY_DNS\" == \"x\" ]; then PRIMARY_DNS=\"8.8.8.8\"; fi;\n";
		inputsStr = inputsStr + "if [ \"x$SECONDARY_DNS\" == \"x\" ]; then SECONDARY_DNS=\"8.8.4.4\"; fi;\n";
		inputsStr = inputsStr + "\ncat > install-inputs <<EOF\n";
		for (Entry<String, String> entry : properties.entrySet()) {
			inputsStr = inputsStr + entry.getKey() + "=\"$" + entry.getKey()
					+ "\"\n";

		}
		inputsStr = inputsStr + "EOF\n\n";
	}

	public void finalizeScripts() throws Exception {
		String str = Util.readFileSimple(LFSParser.outputDirectory
				+ File.separator + "1.sh");
		str = str.replace("set +h\n", "set +h\n\n" + inputsStr + "\n");
		FileOutputStream fileOutputStream = new FileOutputStream(
				LFSParser.outputDirectory + File.separator + "1.sh");
		fileOutputStream.write(str.getBytes());
		fileOutputStream.close();
		File[] files = new File(LFSParser.outputDirectory).listFiles();
		for (File file : files) {
			if (!file.getName().equals("1.sh") && !file.isDirectory()) {
				str = Util.readFileSimple(file.getAbsolutePath());
				str = str.replace("set +h\n", "set +h\n\n. install-inputs\n\n");
				fileOutputStream = new FileOutputStream(file.getAbsolutePath());
				fileOutputStream.write(str.getBytes());
				fileOutputStream.close();
			}
		}
	}
}
