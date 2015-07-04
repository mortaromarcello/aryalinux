package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;

@SuppressWarnings("serial")
public class EditUserCommandsDialog extends JDialog implements ActionListener,
		ItemListener {
	private JPanel buttonPanel;
	private JPanel northPanel;
	private JComboBox<String> comboBox;
	private JButton okButton, cancelButton;
	private JButton removeButton;
	private JPanel rightPanel;
	private JTextArea commandsArea;
	private BLFSPackage blfsPackage;

	public EditUserCommandsDialog(BLFSPackage blfsPackage) {
		super(BLFSParserUI.instance, "Document Remover");
		this.blfsPackage = blfsPackage;
		comboBox = new JComboBox<String>();

		okButton = new JButton("Ok");
		cancelButton = new JButton("Cancel");
		removeButton = new JButton("Remove");

		rightPanel = new JPanel(new GridLayout(1, 2));
		rightPanel.add(okButton);
		rightPanel.add(cancelButton);

		northPanel = new JPanel(new BorderLayout());
		northPanel.add(comboBox);
		northPanel.add(removeButton, "East");

		commandsArea = new JTextArea();

		buttonPanel = new JPanel(new BorderLayout());
		buttonPanel.add(rightPanel, "East");

		add(northPanel, "North");
		add(new JScrollPane(commandsArea), "Center");
		add(buttonPanel, "South");


		for (UserCommand command : blfsPackage.getCommands()) {
			comboBox.addItem(command.getCommand());
			commandsArea.append(command.getCommand() + "\n");
		}


		removeButton.addActionListener(this);
		okButton.addActionListener(this);
		cancelButton.addActionListener(this);

		comboBox.addItemListener(this);
		
		setSize(600, 350);
		setModal(true);
		setVisible(true);
	}

	public void actionPerformed(ActionEvent e) {
		System.out.println("sdfsd");
		if (e.getActionCommand().equals("Remove")) {
			System.out.println("Removing");
			int index = comboBox.getSelectedIndex();
			comboBox.removeItemAt(index);
			blfsPackage.getCommands().remove(index);
			commandsArea.setText("");
			for (UserCommand command : blfsPackage.getCommands()) {
				commandsArea.append(command.getCommand() + "\n");
			}
		}
	}

	public void itemStateChanged(ItemEvent e) {
		// TODO Auto-generated method stub

	}
}
