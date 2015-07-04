package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JSeparator;

@SuppressWarnings("serial")
public class OkCancelPanel extends JPanel implements ActionListener {
	private JButton ok;
	private JButton cancel;
	private OkCancelListener listener;

	public OkCancelPanel() {
		super(new BorderLayout(3, 3));

		ok = new JButton("Ok");
		cancel = new JButton("Cancel");

		JPanel temp = new JPanel(new GridLayout(1, 0, 3, 3));
		temp.add(ok);
		temp.add(cancel);

		add(temp, "East");

		add(new JSeparator(JSeparator.HORIZONTAL), "North");

		ok.addActionListener(this);
		cancel.addActionListener(this);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getSource() == ok) {
			listener.onOk();
		} else if (e.getSource() == cancel) {
			listener.onCancel();
		}
	}

	public void setListener(OkCancelListener listener) {
		this.listener = listener;
	}
}
