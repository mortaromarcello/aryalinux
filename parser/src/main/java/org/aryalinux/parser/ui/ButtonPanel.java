package org.aryalinux.parser.ui;

import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;

@SuppressWarnings("serial")
public class ButtonPanel extends JPanel implements ActionListener {
	private JButton ok, cancel;
	private ActionListener actionListener;

	public ButtonPanel() {
		super(new FlowLayout(FlowLayout.RIGHT));
		JPanel jPanel = new JPanel();
		jPanel.setLayout(new GridLayout(1, 2));

		ok = new JButton("Ok");
		cancel = new JButton("Cancel");

		jPanel.add(ok);
		jPanel.add(cancel);

		add(jPanel);

		ok.addActionListener(this);
		cancel.addActionListener(this);
	}

	public void actionPerformed(ActionEvent e) {
		actionListener.actionPerformed(e);
	}

	public void setActionListener(ActionListener actionListener) {
		this.actionListener = actionListener;
	}
}
