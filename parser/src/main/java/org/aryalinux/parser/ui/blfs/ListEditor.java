package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EtchedBorder;

@SuppressWarnings({ "serial", "rawtypes" })
public class ListEditor<E> extends JPanel implements ActionListener, MouseListener {
	private JPanel buttonPanel;
	private JButton add, remove, edit;
	private JList<String> items;
	private DefaultListModel<String> itemsModel;
	private List<E> data;
	private ListItemEditor itemEditor;
	private ListItemCreator listItemCreator;

	public ListEditor(String title) {
		setLayout(new BorderLayout());
		buttonPanel = new JPanel();
		remove = new JButton("Remove");
		add = new JButton("Add");
		edit = new JButton("Edit");
		itemsModel = new DefaultListModel<String>();
		items = new JList<String>(itemsModel);
		items.addMouseListener(this);
		buttonPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		JPanel tempPanel = new JPanel(new GridLayout(1, 0));
		tempPanel.add(add);
		tempPanel.add(remove);
		tempPanel.add(edit);
		buttonPanel.add(tempPanel);
		add(buttonPanel, "South");
		add(new JScrollPane(items));
		add(new JLabel(title), "North");
		add.addActionListener(this);
		remove.addActionListener(this);
		edit.addActionListener(this);
		setBorder(BorderFactory.createEtchedBorder(EtchedBorder.LOWERED));
		data = new ArrayList<E>();
	}

	public void setData(List<E> data) {
		this.data = data;
		itemsModel.clear();
		for (Object ref : data) {
			itemsModel.addElement(ref.toString());
		}
	}

	@SuppressWarnings("unchecked")
	public void actionPerformed(ActionEvent e) {
		if (e.getActionCommand().equals("Remove")) {
			int index = items.getSelectedIndex();
			if (index >= 0) {
				itemsModel.remove(index);
				data.remove(index);
			}
		}
		if (e.getActionCommand().equals("Add")) {
			try {
				data.add((E) listItemCreator.showCreator());
				itemsModel.addElement(data.get(itemsModel.size()).toString());
			} catch (Exception e1) {
				JOptionPane.showMessageDialog(this,
						"Could not create the Message.",
						"Message create error", JOptionPane.ERROR_MESSAGE);
				e1.printStackTrace();
			}
		}
		if (e.getActionCommand().equals("Edit")) {
			int index = items.getSelectedIndex();
			if (index >= 0) {
				try {
					E ref = (E)itemEditor.showEditor(data.get(index));
					System.out.println("Editor hidden");
					data.set(index, ref);
					System.out.println(ref);
					itemsModel.set(index, ref.toString());
				} catch (Exception e1) {
					JOptionPane.showMessageDialog(this,
							"Could not edit the Message.",
							"Message edit error", JOptionPane.ERROR_MESSAGE);
					e1.printStackTrace();
				}
			}
		}
	}

	public void setEditor(ListItemEditor listItemEditor) {
		this.itemEditor = listItemEditor;
	}

	public void setCreator(ListItemCreator listItemCreator) {
		this.listItemCreator = listItemCreator;
	}

	@SuppressWarnings("unchecked")
	public void mouseClicked(MouseEvent e) {
		if (e.getSource() == items && e.getClickCount() == 2) {
			int index = items.getSelectedIndex();
			if (index >= 0) {
				try {
					data.set(index, (E) itemEditor.showEditor(data.get(index)));
					itemsModel.set(index, data.get(index).toString());
				} catch (Exception e1) {
					JOptionPane.showMessageDialog(this,
							"Could not edit the Message.",
							"Message edit error", JOptionPane.ERROR_MESSAGE);
					e1.printStackTrace();
				}
			}
		}
	}

	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	public void clear() {
		itemsModel.clear();
	}
	
	public List<E> getData() {
		return data;
	}
}
