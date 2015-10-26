package lfsparser;

public class RulesEngine {
	private static String procpsNg(String command) {
		command = command.replace("sed -i -r 's|(pmap_initname)\\\\\\$|\\1|' testsuite/pmap.test/pmap.exp\n\n", "");
		return command;
	}
	private static String shadow(String command) {
		command = command.replace("passwd root\n", "");
		return command;
	}
	private static String gcc(String command) {
		command = command.replace("ulimit -s 32768\n", "");
		return command;
	}
	private static String gmp(String command) {
		command = command.replace("<em class=\"parameter\"><code>ABI=32</em> ./configure ...\n", "");
		command = command.replace("awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log", "");
		return command;
	}
	private static String glibc(String command) {
		command = command.replace("patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch", "if [ $(uname -m) != \"x86_64\" ]\nthen\n\tpatch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch\nfi\n");
		command = command.replace("<em class=\"replaceable\"><code><xxx></em>", "$TIMEZONE");
		command = command.replace("tzselect\n", "");
		return command;
	}
	public static String applyRules(String command) {
		command = glibc(command);
		command = gmp(command);
		command = gcc(command);
		command = shadow(command);
		command = procpsNg(command);
		command = command.replace("echo \"quit\" | ./bc/bc -l Test/checklib.b\n", "");
		command = command.replace("<em class=\"replaceable\"><code><paper_size></em>", "$PAPERSIZE");
		command = command.replace("vim -c ':options'\n", "");
		command = command.replace("exec /bin/bash --login +h\n", "");
		command = command.replace("su nobody -s /bin/bash \\\n", "");
		return command;
	}
}
