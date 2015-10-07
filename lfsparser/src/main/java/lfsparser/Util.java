package lfsparser;

import java.io.FileInputStream;
import java.util.StringTokenizer;

public class Util {
	private static int stepIndex = 0;
	
	public static String readFileSpecial(String filePath) throws Exception {
		FileInputStream fin = new FileInputStream(filePath);
		byte[] data = new byte[fin.available()];
		fin.read(data);
		String str = new String(data);
		str = str.replace("\n", "br3ak");
		str = str.replace("=br3ak", "=");
		fin.close();
		return str;
	}
	
	public static String removeEntities(String rawString) {
		rawString = rawString.replace("&amp;", "&");
		rawString = rawString.replace("&lt;", "<");
		rawString = rawString.replace("&gt;", ">");
		rawString = rawString.replace("&quot;", "\"");
		rawString = rawString.replace("&nbsp;", " ");
		rawString = rawString.replace("<code class=\"literal\">", "").replace("</code>", "");
		StringTokenizer st = new StringTokenizer(rawString, "\n", true);
		String processed = "";
		while(st.hasMoreTokens()) {
			String line = st.nextToken();
			if (line.endsWith("check") || (line.contains("make") && line.contains("check")) || 
					line.contains("make check 2>&1 | tee gmp-check-log") ||
					line.contains("make -j1 tests root-tests") ||
					line.contains("su nobody -s /bin/bash -c \"PATH=$PATH make tests\"") ||
					line.contains("bash tests/run.sh --srcdir=$PWD --builddir=$PWD") ||
					(line.contains("make") && line.contains("test")) ||
					line.endsWith("test_summary")) {
				System.out.println(line + " skipped.");
			}
			else {
				processed = processed + line;
			}
		}
		return processed;
	}
	
	public static String getNextStepIndex() {
		stepIndex++;
		if (stepIndex < 10) {
			return "00" + stepIndex;
		}
		else if (stepIndex < 100) {
			return "0" + stepIndex;
		}
		return "" + stepIndex;
	}
}
