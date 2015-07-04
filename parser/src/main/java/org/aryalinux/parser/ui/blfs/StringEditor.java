package org.aryalinux.parser.ui.blfs;

import javax.swing.JScrollPane;
import javax.swing.JTextArea;

@SuppressWarnings("serial")
public class StringEditor extends OkCancelDialog implements
		ListItemEditor<String> {
	private String data, original;
	private JTextArea textArea;

	public StringEditor() {
		textArea = new JTextArea();
		setTitle("Editor");
		add(new JScrollPane(textArea), "Center");
		setSize(500, 250);
		setModal(true);
	}

	public String showEditor(String item) throws Exception {
		if (item != null) {
			this.data = item;
			this.original = "" + item;
			this.textArea.setText(item);
		}
		center(20);
		System.out.println(result);
		if (result == 0) {
			return this.original;
		} else {
			this.data = textArea.getText();
			return this.data;
		}
	}

}
