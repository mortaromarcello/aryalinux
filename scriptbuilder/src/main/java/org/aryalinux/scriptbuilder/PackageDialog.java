package org.aryalinux.scriptbuilder;

import java.awt.BorderLayout;
import java.awt.GridBagConstraints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class PackageDialog extends JPanel implements ActionListener {
	private JPanel mainPanel;
	private JPanel buttonPanel;
	private JTextField name;
	private JTextField sourceUrl;
	private JTextField additionalUrls;
	private JTextArea commands;
	private JButton submitButton;
	private GridBagConstraints gbc;
	private PackageData packageData;
	private JDialog dialog;

	public PackageDialog() {
		setLayout(new BorderLayout());
		name = new JTextField(40);
		sourceUrl = new JTextField(40);
		additionalUrls = new JTextField(40);
		commands = new JTextArea(8, 40);
		submitButton = new JButton("Done");
		mainPanel = new JPanel();
		mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.Y_AXIS));
		mainPanel.add(new JLabel("Name"));
		mainPanel.add(name);
		mainPanel.add(new JLabel("Source URL"));
		mainPanel.add(sourceUrl);
		mainPanel.add(new JLabel("Additional URLs"));
		mainPanel.add(additionalUrls);
		mainPanel.add(new JLabel("Commands"));
		mainPanel.add(new JScrollPane(commands));
		gbc = new GridBagConstraints();
		buttonPanel = new JPanel();
		buttonPanel.setLayout(new BorderLayout());
		buttonPanel.add(submitButton, BorderLayout.EAST);
		add(mainPanel);
		add(buttonPanel, "South");
		submitButton.addActionListener(this);
	}

	public JButton getSubmitButton() {
		return submitButton;
	}

	public void actionPerformed(ActionEvent ae) {
		packageData = new PackageData(sourceUrl.getText(),
				additionalUrls.getText(), commands.getText());
		packageData.setName(name.getText());
		dialog.dispose();
	}

	public void showDialog(JFrame parent) {
		dialog = new JDialog(parent);
		dialog.setModal(true);
		dialog.add(this);
		dialog.pack();
		dialog.setVisible(true);
	}

	public PackageData getPackageData() {
		return packageData;
	}
}
