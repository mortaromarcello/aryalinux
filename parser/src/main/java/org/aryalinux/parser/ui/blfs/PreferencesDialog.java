package org.aryalinux.parser.ui.blfs;

import java.awt.GridBagConstraints;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.swing.JLabel;
import javax.swing.JTextField;

public class PreferencesDialog extends OkCancelDialogBox {
	private FlexiPanel mainPanel;
	private Map<String, String> propertyNamesAndLabels;
	private Map<String, JTextField> propertyFields;

	public PreferencesDialog() {
		mainPanel = new FlexiPanel();
		propertyNamesAndLabels = new LinkedHashMap<String, String>();
		propertyNamesAndLabels.put("systemd.units.url", "Systemd Units Download URL");
		propertyNamesAndLabels.put("systemd.version", "Systemd Version");
		propertyNamesAndLabels.put("dbus.tarball", "DBus Tarball");
		propertyNamesAndLabels.put("locale", "Locale");
		propertyNamesAndLabels.put("distro.name", "Distribution Name");
		
		propertyFields = new LinkedHashMap<String, JTextField>();
		
		int row = 0;
		mainPanel.gbc.anchor = GridBagConstraints.WEST;
		mainPanel.gbc.fill = GridBagConstraints.BOTH;
		for (Entry<String, String> entry : propertyNamesAndLabels.entrySet()) {
			mainPanel.add(new JLabel(entry.getValue()), 0, row++, 1, 1);
			JTextField tf = new JTextField(30);
			propertyFields.put(entry.getKey(), tf);
			mainPanel.add(tf, 0, row++, 1, 1);
		}
	}
	
}
