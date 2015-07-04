package org.aryalinux.parser.ui.blfs;

import java.awt.Component;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;

import javax.swing.JPanel;

@SuppressWarnings("serial")
public class FlexiPanel extends JPanel {
	protected GridBagConstraints gbc;

	public FlexiPanel() {
		gbc = new GridBagConstraints();
		setLayout(new GridBagLayout());
	}

	public void add(Component c, int x, int y, int w, int h) {
		gbc.gridx = x;
		gbc.gridy = y;
		gbc.gridwidth = w;
		gbc.gridheight = h;
		add(c, gbc);
	}
}
