package org.aryalinux.parser.ui.blfs;

import javax.swing.JFrame;

public class Test {
	public static void main(String[] args) {
		JFrame frame = new JFrame("Test");
		frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
		frame.setVisible(true);
		NewMetaPackageDialog box = new NewMetaPackageDialog();
		box.setSize(40);
		box.showDialog(frame);
	}
}
