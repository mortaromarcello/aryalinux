package org.aryalinux.parser.ui.blfs;

import java.awt.GridBagConstraints;
import java.util.List;

import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.JTextField;

public class NewMetaPackageDialog extends OkCancelDialogBox {
	private JList<String> packages;
	private DefaultListModel<String> defaultListModel;
	private JTextField packageName;

	public NewMetaPackageDialog() {
		packages = new JList<String>();
		defaultListModel = new DefaultListModel<String>();
		packages.setModel(defaultListModel);
		packageName = new JTextField();
		FlexiPanel mainPanel = new FlexiPanel();
		mainPanel.gbc.weightx = 1.0;
		mainPanel.gbc.fill = GridBagConstraints.BOTH;
		mainPanel.gbc.anchor = GridBagConstraints.WEST;
		mainPanel.add(new JLabel("Package Name"), 0, 0, 1, 1);
		mainPanel.add(packageName, 0, 1, 1, 1);
		mainPanel.add(new JLabel("Dependencies"), 0, 2, 1, 1);
		mainPanel.gbc.weighty = 1.0;
		mainPanel.add(new JScrollPane(packages), 0, 3, 1, 1);
		add(mainPanel);
	}

	public void showDialog(JFrame parent) {
		defaultListModel.clear();
		for (String str : PackageEditor.packages.keySet()) {
			defaultListModel.addElement(str);
		}
		super.showDialog(parent);
	}

	public String getPackageName() {
		return packageName.getText();
	}

	public List<String> getDependencies() {
		return packages.getSelectedValuesList();
	}
}
