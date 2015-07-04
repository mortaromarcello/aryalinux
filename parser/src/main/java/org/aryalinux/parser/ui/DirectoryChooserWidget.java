package org.aryalinux.parser.ui;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.JTextField;

@SuppressWarnings("serial")
public class DirectoryChooserWidget extends JPanel implements ActionListener {
	private JTextField file;
	private JButton select;
	private File selectedFile;

	public DirectoryChooserWidget(String initialDirectory) {
		this();
		file.setText(initialDirectory);
		selectedFile = new File(initialDirectory);
	}

	public DirectoryChooserWidget() {
		super(new BorderLayout(2, 2));
		file = new JTextField(45);
		select = new JButton("Browse...");
		add(file, "Center");
		add(select, "East");
		select.addActionListener(this);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getSource().equals(select)) {
			JFileChooser chooser = new JFileChooser();
			chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			int result = chooser.showDialog(this, "Choose Directory");
			if (result == JFileChooser.APPROVE_OPTION) {
				this.selectedFile = chooser.getSelectedFile();
				file.setText(this.selectedFile.getAbsolutePath());
			}
		}
	}

	public File getSelectedFile() {
		return this.selectedFile;
	}
}
