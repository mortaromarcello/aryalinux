package org.aryalinux.parser.ui.blfs;

import javax.swing.JComboBox;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import org.aryalinux.parser.commons.blfs.UserCommand;

@SuppressWarnings("serial")
public class UserCommandCreator extends OkCancelDialog implements
		ListItemCreator<UserCommand> {
	private JComboBox<String> executedBy;
	private JTextArea textArea;

	public UserCommandCreator() {
		executedBy = new JComboBox<String>(new String[] { "userinput", "root" });
		textArea = new JTextArea();
		add(executedBy, "North");
		add(new JScrollPane(textArea));
	}

	public UserCommand showCreator() throws Exception {
		center(40);
		return new UserCommand(textArea.getText(), executedBy.getSelectedItem()
				.toString());
	}

}
