package org.aryalinux.parser.ui.lfs;

import java.awt.event.ActionEvent;

import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;

import org.aryalinux.parser.lfs.LFSParser;
import org.aryalinux.parser.ui.blfs.BLFSParserUI;

@SuppressWarnings("serial")
public class LFSParserUI extends BLFSParserUI {
	private JTextField sourcePath;
	private JTextField installLogFile;
	private static LFSParserUI instance;

	public LFSParserUI() {
		super("LFS Parser 1.0");

		sourcePath = new JTextField(50);
		sourcePath.setText("/sources");
		installLogFile = new JTextField(50);
		installLogFile.setText("/sources/install-log");

		add(new JLabel("Source Path (in scripts) :"), 0, 4, 1, 1);
		add(sourcePath, 0, 5, 1, 1);
		add(new JLabel("Install Log (in scripts) :"), 0, 6, 1, 1);
		add(installLogFile, 0, 7, 1, 1);
		instance = this;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if (e.getSource().equals(done)) {
			try {
				Thread th = new Thread() {
					public void run() {
						try {
							LFSParser.rootDirectory = bookDir.getSelectedFile()
									.getAbsolutePath();
							LFSParser.outputDirectory = outputDir
									.getSelectedFile().getAbsolutePath();
							LFSParser.sourcePath = sourcePath.getText();
							LFSParser.logPath = installLogFile.getText();
							LFSParser.startParsing();
							JOptionPane
									.showMessageDialog(LFSParserUI.instance,
											"Done with script generation. Click OK to exit.");
							System.exit(0);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				};
				th.start();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}

	public static void main(String[] args) {
		new LFSParserUI().setVisible(true);
	}
}
