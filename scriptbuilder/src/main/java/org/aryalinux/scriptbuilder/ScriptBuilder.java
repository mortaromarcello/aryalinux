package org.aryalinux.scriptbuilder;

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileOutputStream;
import java.util.StringTokenizer;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.UIManager;

public class ScriptBuilder extends JFrame implements ActionListener {
	private JButton add;
	private JTextArea textArea;
	private static String destinationDir = "/var/cache/alps/scripts";

	public ScriptBuilder() {
		add = new JButton("Add Package");
		add.setMnemonic('a');
		JPanel panel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
		panel.add(add);
		add(panel, "North");
		add.addActionListener(this);
		textArea = new JTextArea();
		add(new JScrollPane(textArea));
	}

	public void actionPerformed(ActionEvent ae) {
		PackageDialog buttonDialog = new PackageDialog();
		buttonDialog.showDialog(this);
		PackageData data = buttonDialog.getPackageData();
		if (data != null) {
			String script = getScript(data);
			textArea.setText(script);

			try {
				File file = new File(new File(ScriptBuilder.destinationDir),
						data.getName() + ".sh");
				FileOutputStream fout = new FileOutputStream(file);
				fout.write(script.getBytes());
				fout.close();

				file.setExecutable(true);
			} catch (Exception ex) {
				JOptionPane.showMessageDialog(this, ex.getMessage());
			}
		}
	}

	public String getScript(PackageData data) {
		String script = "#!/bin/bash\n" + "set -e\n" + "set +h\n" + "\n"
				+ ". /etc/alps/alps.conf\n" + "\n" + "KDE_PREFIX=/usr" + "\n"
				+ "cd $SOURCE_DIR\n" + "\n" + "URL=" + data.getSourceUrl()
				+ "\n" + "wget -nc $URL\n";
		StringTokenizer st = new StringTokenizer(data.getAdditionalUrls(), " ,");
		if (st.countTokens() > 0) {
			while (st.hasMoreTokens()) {
				String url = st.nextToken();
				script = script + "wget -nc " + url + "\n";
			}
		}
		script = script + "TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`\n"
				+ "DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `\n"
				+ "\n" + "tar -xf $TARBALL\n" + "\n" + "cd $DIRECTORY\n" + "\n"
				+ data.getCommands();
		script = script + "\n\ncd $SOURCE_DIR\n" + "rm -rf $DIRECTORY\n" + "\n"
				+ "echo \"" + data.getName()
				+ "=>`date`\" | sudo tee -a $INSTALLED_LIST\n" + "\n";
		return script;
	}

	public static void main(String[] args) throws Exception {
		UIManager.setLookAndFeel("com.sun.java.swing.plaf.gtk.GTKLookAndFeel");
		ScriptBuilder builder = new ScriptBuilder();
		builder.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		builder.setExtendedState(JFrame.MAXIMIZED_BOTH);
		builder.setVisible(true);
	}
}
