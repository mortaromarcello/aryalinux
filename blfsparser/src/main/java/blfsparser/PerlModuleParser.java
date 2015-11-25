package blfsparser;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class PerlModuleParser {
	private List<PerlModule> perlModules;

	public PerlModuleParser() {
		perlModules = new ArrayList<PerlModule>();
	}

	public void parse(Element document) throws Exception {
		Elements headingAchors = document.select("h3 a");
		List<String> names = new ArrayList<String>();
		List<Element> itemizedLists = new ArrayList<Element>();
		for (int i = 0; i < headingAchors.size(); i++) {
			names.add(headingAchors.get(i).attr("id"));
			itemizedLists.add(Util.getNextSiblingByClass(headingAchors.get(i).parent(), "itemizedlist"));
			// System.out.println(names.get(i));
			// System.out.println(itemizedLists.get(i));
			PerlModule module = new PerlModule();
			module.setName(names.get(i));
			// System.out.println(itemizedLists.get(i));
			// System.out.println(Util.getNextRecursiveChildByClass(itemizedLists.get(i),
			// "ulink"));
			module.setDownloadUrl(Util.getNextRecursiveChildByClass(itemizedLists.get(i), "ulink").attr("href"));
			// System.out.println(module.getDownloadUrl());
			Element depsDiv = Util.getNextRecursiveChildByClass(itemizedLists.get(i), "itemizedlist");
			if (depsDiv == null) {
				// System.out.println("No deps...");
			} else {
				// System.out.println(depsDiv);
				parseDependencies(module, depsDiv);
			}
			perlModules.add(module);
		}
	}

	private void parseDependencies(PerlModule parent, Element depsDiv) throws Exception {
		Elements lis = depsDiv.child(0).children();
		for (Element li : lis) {
			// System.out.println(li);
			PerlModule module = new PerlModule();
			if (Util.getNextRecursiveChildByClass(li, "xref") != null) {
				module.setName(Util.getNextRecursiveChildByClass(li, "xref").attr("href"));
				module.setDownloadUrl(Util.getNextRecursiveChildByClass(li, "xref").attr("href"));
			} else {
				module.setName(Util.getNextRecursiveChildByClass(li, "ulink").html());
				module.setDownloadUrl(Util.getNextRecursiveChildByClass(li, "ulink").attr("href"));
			}
			module.setName(module.getName().replace("::", "-").toLowerCase());
			module.setName(module.getName().replace("&nbsp;", "").replace("br3ak", "").replace(" ", ""));
			if (module.getName().indexOf("&nbsp;") != -1) {
				module.setName(module.getName().substring(0, module.getName().indexOf("&nbsp;")));
			}
			if (module.getDownloadUrl().contains("#")) {
				// Add another module as dep
			} else if (module.getDownloadUrl().endsWith(".html")) {
				// Add another package as dep
			} else if (module.getDownloadUrl().startsWith("http://")) {
				// Let's parse online page....
				System.out.print(".");
				// System.out.println(module.getDownloadUrl());
				Document onlineDoc = null;
				try {
					onlineDoc = Jsoup.parse(new URL(module.getDownloadUrl()), 10000);
				} catch (Exception ex) {
					System.out.println("Could not download : " + module.getDownloadUrl());
				}
				Elements anchors = onlineDoc.select("a");

				for (Element anchor : anchors) {
					if (anchor.attr("href").endsWith(".tar.gz")) {
						if (anchor.attr("href").startsWith("/")) {
							module.setDownloadUrl(
									module.getDownloadUrl().substring(0, module.getDownloadUrl().indexOf(".org") + 4)
											+ anchor.attr("href"));
						} else {
							module.setDownloadUrl(module.getDownloadUrl() + "/" + anchor.attr("href"));
						}
					}
				}
			}
			if (!module.getDownloadUrl().endsWith(".tar.gz")) {
				// System.out.println(module.getDownloadUrl());
			}
			Element moduleDepsDiv = Util.getNextRecursiveChildByClass(li, "itemizedlist");
			if (moduleDepsDiv != null) {
				parseDependencies(module, moduleDepsDiv);
			}
			parent.getDependencies().add(module);
		}
	}

	private void addRecursive(PerlModule root, Set<PerlModule> collection) {
		for (PerlModule child : root.getDependencies()) {
			if (child.getDownloadUrl().endsWith(".tar.gz")) {
				addRecursive(child, collection);
				collection.add(child);
			}
		}
	}

	public void generate(String outputDir) throws Exception {
		Set<PerlModule> allModules = new LinkedHashSet<PerlModule>();
		for (PerlModule module : perlModules) {
			addRecursive(module, allModules);
		}

		/*
		 * for (PerlModule module : perlModules) { for (PerlModule child :
		 * module.getDependencies()) { boolean present = false; for (PerlModule
		 * m : allModules) { if (m.getName().equals(child.getName())) { present
		 * = true; } } if (!present &&
		 * child.getDownloadUrl().endsWith(".tar.gz")) { allModules.add(child);
		 * } } allModules.add(module); }
		 */

		// System.out.println(perlModules);
		for (PerlModule module : allModules) {
			if (!module.getName().endsWith(".html") && !module.getName().contains("perl-build-install")) {
				String output = "#!/bin/bash\n" + "\n" + "set -e\n" + "set +h\n" + "\n" + ". /etc/alps/alps.conf\n"
						+ "\n";
				for (PerlModule dep : module.getDependencies()) {
					if (!dep.getName().contains("perl-build-install")) {
						if (dep.getName().contains("perl-modules")) {
							output = output + "#REQ:" + dep.getName().replace(".html", "") + "\n";
						} else if (dep.getName().endsWith(".html")) {
							output = output + "#REQ:" + dep.getName().replace("/", "_").replace(".html", "");
						} else {
							output = output + "#REQ:perl-modules#" + dep.getName().replace(".html", "") + "\n";
						}
					}
				}
				output = output + "\nURL=\"" + module.getDownloadUrl() + "\"\n" + "\n" + "cd $SOURCE_DIR\n"
						+ "wget -nc $URL\n" + "TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`\n"
						+ "DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`\n\n" + "tar xf $TARBALL\n"
						+ "cd $DIRECTORY\n" + "\n" + "if [ -f Build.PL ]\n" + "then\n" + "perl Build.PL &&\n"
						+ "./Build &&\n" + "sudo ./Build install\n" + "fi\n" + "\n" + "if [ -f Makefile.PL ]\n"
						+ "then\n" + "perl Makefile.PL &&\n" + "make &&\n" + "sudo make install\n" + "fi\n"
						+ "cd $SOURCE_DIR\n\n" + "sudo rm -rf $DIRECTORY\n\n";
				FileOutputStream fout = null;
				File file = null;
				if (module.getName().contains("perl-modules")) {
					output = output + "echo \"" + module.getName() + "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n";
					fout = new FileOutputStream(
							outputDir + File.separator + "general_" + module.getName().replace(".html", "") + ".sh");
					file = new File(
							outputDir + File.separator + "general_" + module.getName().replace(".html", "") + ".sh");
				} else {
					output = output + "echo \"perl-modules#" + module.getName()
							+ "=>`date`\" | sudo tee -a $INSTALLED_LIST\n\n";
					fout = new FileOutputStream(outputDir + File.separator + "perl-modules#"
							+ module.getName().replace(".html", "") + ".sh");
					file = new File(outputDir + File.separator + "perl-modules#" + module.getName().replace(".html", "")
							+ ".sh");
				}
				fout.write(output.getBytes());
				fout.close();
				file.setExecutable(true);
			}
		}
	}
}
