package org.aryalinux.parser.lfs;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class PostLFSGenerator {
	private static List<String> scripts;

	static {
		scripts = new ArrayList<String>();
		scripts.add("01-which.sh");
		scripts.add("02-lsb-release.sh");
		scripts.add("03-os-prober.sh");
		scripts.add("04-busybox.sh");
		scripts.add("05-bootloader.sh");
		scripts.add("06-openssl.sh");
		scripts.add("07-wget.sh");
	}

	public static void generate() throws Exception {
		File dir = new File(LFSParser.outputDirectory + File.separator
				+ "postlfs");
		dir.mkdirs();
		for (String script : scripts) {
			InputStream inputStream = PostLFSGenerator.class.getClassLoader()
					.getResourceAsStream(script);
			byte[] data = new byte[inputStream.available()];
			inputStream.read(data);
			inputStream.close();
			FileOutputStream fileOutputStream = new FileOutputStream(new File(
					dir, script));
			fileOutputStream.write(data);
			fileOutputStream.close();
		}
	}
}
