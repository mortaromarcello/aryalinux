package org.aryalinux.parser.ui.blfs;

import javax.swing.JScrollPane;
import javax.swing.JTextArea;

@SuppressWarnings("serial")
public class StringCreator extends OkCancelDialog implements
		ListItemCreator<String> {
	private JTextArea string;

	public StringCreator() {
		string = new JTextArea();
		add(new JScrollPane(string));
		setModal(true);
	}

	public String showCreator() throws Exception {
		center(20);
		return string.getText();
	}

}
