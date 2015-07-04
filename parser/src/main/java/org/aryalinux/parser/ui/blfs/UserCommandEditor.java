package org.aryalinux.parser.ui.blfs;

import javax.swing.JComboBox;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import org.aryalinux.parser.commons.blfs.UserCommand;

@SuppressWarnings("serial")
public class UserCommandEditor extends OkCancelDialog implements
		ListItemEditor<UserCommand> {
	private UserCommand data, original;
	private JTextArea commands;
	private JComboBox<String> executedBy;

	public UserCommandEditor() {
		commands = new JTextArea();
		executedBy = new JComboBox<String>(new String[] { "root", "userinput" });
		setTitle("User Command Editor");
		add(executedBy, "North");
		add(new JScrollPane(commands), "Center");
		setSize(600, 300);
		setModal(true);
	}

	public UserCommand showEditor(UserCommand item) throws Exception {
		if (item != null) {
			this.data = item;
			this.original = item.clone();
			executedBy.setSelectedItem(item.getExecutedBy());
			commands.setText(item.getCommand());
		}
		center(40);
		if (result == 0) {
			return this.original;
		} else {
			this.data = new UserCommand(commands.getText(), executedBy
					.getSelectedItem().toString());
			return this.data;
		}
	}

}
