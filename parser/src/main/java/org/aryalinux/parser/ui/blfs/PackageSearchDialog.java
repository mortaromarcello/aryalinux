package org.aryalinux.parser.ui.blfs;

import java.awt.GridBagLayout;
import java.awt.GridLayout;

import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

@SuppressWarnings("serial")
public class PackageSearchDialog extends OkCancelDialog {
	private JTextField value;
	private JComboBox<String> criteria;

	public PackageSearchDialog() {
		criteria = new JComboBox<String>(new String[] { "Name", "Dependencies",
				"Optional Dependencies", "Commands" });
		value = new JTextField(30);
		JPanel tempPanel = new JPanel(new GridBagLayout());
		JPanel mainPanel = new JPanel(new GridLayout(0, 1));
		tempPanel.add(mainPanel);
		mainPanel.add(new JLabel("Criteria"));
		mainPanel.add(criteria);
		mainPanel.add(new JLabel("Keywords"));
		mainPanel.add(value);
		add(tempPanel);
	}

	public String getCriteria() {
		return criteria.getSelectedItem().toString();
	}

	public String getKeywords() {
		return value.getText();
	}

	public int getResult() {
		return result;
	}
}
