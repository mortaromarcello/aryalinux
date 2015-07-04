package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.TextEvent;
import java.awt.event.TextListener;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;

@SuppressWarnings("serial")
public class NewPackagePanel extends JPanel implements ActionListener,
		ItemListener, TextListener {
	private JTextField name;
	private JTextField tarball;
	private JTextField directoryName;
	private ListEditor<String> dependencies, optionalDependencies,
			downloadUrls;
	private ListEditor<UserCommand> commands;
	private JPanel listsContainer, textfieldsContainer;
	private BLFSPackage pack;

	public NewPackagePanel() {
		name = new JTextField();
		tarball = new JTextField();
		directoryName = new JTextField();
		dependencies = new ListEditor<String>("Dependencies");
		dependencies.setEditor(new StringEditor());
		dependencies.setCreator(new StringCreator());
		optionalDependencies = new ListEditor<String>("Optional Dependencies");
		optionalDependencies.setEditor(new StringEditor());
		optionalDependencies.setCreator(new StringCreator());
		commands = new ListEditor<UserCommand>("Commands");
		commands.setEditor(new UserCommandEditor());
		commands.setCreator(new UserCommandCreator());
		downloadUrls = new ListEditor<String>("Download URLs");
		downloadUrls.setEditor(new StringEditor());
		downloadUrls.setCreator(new StringCreator());

		textfieldsContainer = new JPanel(new GridLayout(6, 1));
		listsContainer = new JPanel(new GridLayout(2, 2));

		setLayout(new BorderLayout());

		textfieldsContainer.add(new JLabel("Package Name"));
		textfieldsContainer.add(name);
		textfieldsContainer.add(new JLabel("Tarball Name"));
		textfieldsContainer.add(tarball);
		textfieldsContainer.add(new JLabel("Source Directory Name"));
		textfieldsContainer.add(directoryName);

		listsContainer.add(downloadUrls);
		listsContainer.add(dependencies);
		listsContainer.add(optionalDependencies);
		listsContainer.add(commands);

		add(textfieldsContainer, "North");
		add(listsContainer, "Center");
	}

	public void itemStateChanged(ItemEvent e) {
		// TODO Auto-generated method stub

	}

	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub

	}

	public void textValueChanged(TextEvent e) {
		if (e.getSource() == name) {
			pack.setName(name.getText());
		}
		if (e.getSource() == tarball) {
			pack.setTarball(tarball.getText());
		}
		if (e.getSource() == directoryName) {
			pack.setDirectoryName(directoryName.getText());
		}
	}

	public BLFSPackage getPackage() {
		BLFSPackage pack = new BLFSPackage();
		pack.setName(name.getText());
		pack.setTarball(tarball.getText());
		pack.setDirectoryName(directoryName.getText());
		pack.setDownloadUrls(downloadUrls.getData());
		pack.setOptionalDeps(optionalDependencies.getData());
		pack.setDependencies(dependencies.getData());
		pack.setCommands(commands.getData());
		return pack;
	}
}
