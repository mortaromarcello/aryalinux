package org.aryalinux.parser.ui.blfs;

import java.awt.GridBagLayout;
import java.awt.GridLayout;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

@SuppressWarnings("serial")
public class PackageNameReplaceDialog extends OkCancelDialog {
	private JPanel tempPanel;
	private JPanel componentsPanel;
	private JTextField search;
	private JTextField replace;

	public PackageNameReplaceDialog() {
		setTitle("Package name replacement");
		tempPanel = new JPanel(new GridLayout(4, 1));
		search = new JTextField(30);
		replace = new JTextField(30);
		tempPanel.add(new JLabel("Search"));
		tempPanel.add(search);
		tempPanel.add(new JLabel("Replace"));
		tempPanel.add(replace);
		componentsPanel = new JPanel(new GridBagLayout());
		componentsPanel.add(tempPanel);
		add(componentsPanel);
	}

	public String getSearchString() {
		return search.getText();
	}

	public String getReplaceString() {
		return replace.getText();
	}
	
	public int getResult() {
		return result;
	}
}
