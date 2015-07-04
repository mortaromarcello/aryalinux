package org.aryalinux.parser.ui.blfs;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

import javax.swing.JDialog;
import javax.swing.JFrame;

public class OkCancelDialogBox implements OkCancelListener, WindowListener {
	private Component mainComponent;
	private JDialog theDialog;
	private OkCancelPanel thePanel;
	private Dimension dimension;
	private int result;

	public OkCancelDialogBox() {
		thePanel = new OkCancelPanel();
		thePanel.setListener(this);
	}

	public void onOk() {
		result = 1;
		theDialog.setVisible(false);
	}

	public void onCancel() {
		result = 0;
		theDialog.setVisible(false);
	}

	public void setSize(int percent) {
		Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
		dimension = new Dimension((dim.width / 100 * percent),
				(dim.height / 100 * percent));
	}

	public void setSize(int width, int height) {
		dimension = new Dimension(width, height);
	}

	public void showDialog(JFrame parent) {
		theDialog = new JDialog(parent);
		theDialog.add(thePanel, "South");
		theDialog.add(mainComponent);
		if (dimension != null) {
			theDialog.setSize(dimension);
		} else {
			theDialog.pack();
		}
		Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
		theDialog.setLocation((dim.width - theDialog.getWidth()) / 2,
				(dim.height - theDialog.getHeight()) / 2);
		theDialog.setModal(true);
		theDialog.setVisible(true);
	}

	public int getResult() {
		return result;
	}

	public void windowOpened(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	public void windowClosing(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	public void windowClosed(WindowEvent e) {
		result = 0;
		theDialog.setVisible(false);
	}

	public void windowIconified(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	public void windowDeiconified(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	public void windowActivated(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	public void windowDeactivated(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	public void add(Component c) {
		this.mainComponent = c;
	}
}
