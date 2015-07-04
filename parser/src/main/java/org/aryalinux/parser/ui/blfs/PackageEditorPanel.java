package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;

@SuppressWarnings("serial")
public class PackageEditorPanel extends JPanel implements ActionListener,
		ItemListener, KeyListener {
	private JTextField name;
	private JTextField tarball;
	private JTextField directoryName;
	private ListEditor<String> dependencies, optionalDependencies,
			downloadUrls;
	private ListEditor<UserCommand> commands;
	private JPanel listsContainer, textfieldsContainer;
	private BLFSPackage pack;

	public PackageEditorPanel() {
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
		name.addKeyListener(this);
		textfieldsContainer.add(new JLabel("Tarball Name"));
		textfieldsContainer.add(tarball);
		tarball.addKeyListener(this);
		textfieldsContainer.add(new JLabel("Source Directory Name"));
		textfieldsContainer.add(directoryName);
		directoryName.addKeyListener(this);
		
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

	public void setPackage(BLFSPackage pack) {
		this.pack = pack;
		name.setText("");
		directoryName.setText("");
		tarball.setText("");
		dependencies.clear();
		optionalDependencies.clear();
		downloadUrls.clear();
		commands.clear();
		if (pack.getName() != null)
			name.setText(pack.getName());
		if (pack.getDirectoryName() != null)
			directoryName.setText(pack.getDirectoryName());
		if (pack.getTarball() != null)
			tarball.setText(pack.getTarball());
		if (pack.getDependencies() != null)
			dependencies.setData(pack.getDependencies());
		if (pack.getOptionalDeps() != null)
			optionalDependencies.setData(pack.getOptionalDeps());
		if (pack.getDownloadUrls() != null)
			downloadUrls.setData(pack.getDownloadUrls());
		if (pack.getCommands() != null)
			commands.setData(pack.getCommands());
	}

	public void keyPressed(KeyEvent arg0) {
		// TODO Auto-generated method stub

	}

	public void keyReleased(KeyEvent arg0) {
		// TODO Auto-generated method stub

	}

	public void keyTyped(KeyEvent e) {
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
}
