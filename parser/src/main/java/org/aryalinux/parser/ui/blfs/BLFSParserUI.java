package org.aryalinux.parser.ui.blfs;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import org.aryalinux.parser.blfs.BLFSParser;
import org.aryalinux.parser.ui.DirectoryChooserWidget;
import org.aryalinux.parser.utils.Util;

@SuppressWarnings("serial")
public class BLFSParserUI extends JFrame implements ActionListener {
	private GridBagLayout gbl;
	private GridBagConstraints gbc;
	protected DirectoryChooserWidget bookDir;
	protected DirectoryChooserWidget outputDir;
	protected JLabel status;
	protected JButton done;
	public static BLFSParserUI instance;

	public BLFSParserUI(String title) {
		super(title);
		gbl = new GridBagLayout();
		gbc = new GridBagConstraints();
		setLayout(gbl);
		bookDir = new DirectoryChooserWidget(
				"D:\\Experiments\\lfs-books\\blfs\\www.linuxfromscratch.org\\blfs\\view\\stable");
		outputDir = new DirectoryChooserWidget(
				"D:\\Experiments\\scripts\\blfs-stable");
		status = new JLabel();
		addComponents();
		pack();
		setSize(getWidth() + 200, getHeight() + 100);
		center();
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		instance = this;
	}

	public void addComponents() {
		gbc.fill = GridBagConstraints.BOTH;
		gbc.anchor = GridBagConstraints.WEST;
		add(new JLabel("Book Directory:"), 0, 0, 1, 1);
		add(new JLabel("Output Directory:"), 0, 2, 1, 1);
		add(bookDir, 0, 1, 1, 1);
		add(outputDir, 0, 3, 1, 1);

		done = new JButton("Start Parsing...");
		done.addActionListener(this);
		JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 0, 5));
		buttonPanel.add(done);
		add(buttonPanel, 0, 9, 1, 1);
		add(status, 0, 10, 1, 1);
	}

	public void add(Component c, int x, int y, int w, int h) {
		gbc.gridx = x;
		gbc.gridy = y;
		gbc.gridwidth = w;
		gbc.gridheight = h;
		add(c, gbc);
	}

	public void center() {
		Dimension ss = Toolkit.getDefaultToolkit().getScreenSize();
		setLocation((ss.width - getWidth()) / 2, (ss.height - getHeight()) / 2);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getSource().equals(done)) {
			try {
				Thread th = new Thread() {
					public void run() {
						try {
							Util.bookDirectory = bookDir.getSelectedFile()
									.getAbsolutePath();
							Util.outputDirectory = outputDir.getSelectedFile()
									.getAbsolutePath();
							BLFSParser.bookDirectory = bookDir
									.getSelectedFile().getAbsolutePath();
							BLFSParser.outputDirectory = outputDir
									.getSelectedFile().getAbsolutePath();
							String systemdUnitsPage = BLFSParser.bookDirectory
									+ File.separator + "introduction"
									+ File.separator + "systemd-units.html";
							Util.isSystemd = new File(systemdUnitsPage)
									.exists();
							BLFSParser.startParsing(status);
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

	public void setStatus(String statusMessage) {
		this.status.setText(statusMessage);
	}

	public static void main(String[] args) {
		new BLFSParserUI("BLFS Parser 1.0").setVisible(true);
		/*
		 * BLFSParser.applicationContext = new ClassPathXmlApplicationContext(
		 * "beans.xml");
		 */
	}
}
