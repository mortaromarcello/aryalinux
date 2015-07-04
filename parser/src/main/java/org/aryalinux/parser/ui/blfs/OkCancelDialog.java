package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;

@SuppressWarnings("serial")
public class OkCancelDialog extends JDialog implements ActionListener {
	private JPanel buttonPanel;
	private JButton ok, cancel;
	protected int result;

	public OkCancelDialog() {
		setLayout(new BorderLayout(5, 5));
		buttonPanel = new JPanel(new BorderLayout());
		JPanel temp = new JPanel(new GridLayout(1, 0, 5, 5));
		ok = new JButton("Ok");
		cancel = new JButton("Cancel");
		temp.add(ok);
		temp.add(cancel);
		buttonPanel.add(temp, "East");
		add(buttonPanel, "South");
		ok.addActionListener(this);
		cancel.addActionListener(this);
		setModal(true);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getActionCommand().equals("Ok")) {
			result = 1;
		}
		if (e.getActionCommand().equals("Cancel")) {
			result = 0;
		}
		setVisible(false);
	}

	public void center(int w, int h) {
		setSize(w, h);
		Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
		setLocation((dim.width - w) / 2, (dim.height - h) / 2);
		setVisible(true);
	}

	public void center(int percent) {
		Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
		setSize(dim.width * percent / 100, dim.height * percent / 100);
		setLocation((dim.width - getWidth()) / 2,
				(dim.height - getHeight()) / 2);
		setVisible(true);
	}
}
