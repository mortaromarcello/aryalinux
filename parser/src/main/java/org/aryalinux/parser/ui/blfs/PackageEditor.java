package org.aryalinux.parser.ui.blfs;

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map.Entry;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.KeyStroke;
import javax.swing.UIManager;

import org.aryalinux.parser.blfs.NewBLFSParser;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.commons.blfs.UserCommand;

@SuppressWarnings("serial")
public class PackageEditor extends JFrame implements ActionListener,
		ItemListener {
	private PackageEditorPanel editorPanel;
	private LinkedHashMap<String, String[]> menuData = new LinkedHashMap<String, String[]>();
	public static LinkedHashMap<String, BLFSPackage> packages;
	private LinkedHashMap<String, KeyStroke> shortcuts = new LinkedHashMap<String, KeyStroke>();
	private JPanel navigator;
	private JComboBox<String> packageNames;
	private List<String> keys;
	private String currentKey;
	private String packagePath;

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public PackageEditor() {
		editorPanel = new PackageEditorPanel();
		add(editorPanel);
		initMenuMap();
		initMenu();
		navigator = new JPanel(new BorderLayout());
		JPanel temp = new JPanel(new GridLayout(1, 0));
		navigator.add(temp, "East");
		JButton next = new JButton("Next");
		next.setMnemonic('n');
		JButton prev = new JButton("Previous");
		prev.setMnemonic('p');
		temp.add(prev);
		temp.add(next);
		prev.addActionListener(this);
		next.addActionListener(this);
		packageNames = new JComboBox();
		packageNames.addItemListener(this);
		navigator.add(packageNames);
		add(navigator, "North");
	}

	public void initMenu() {
		JMenuBar menubar = new JMenuBar();
		for (Entry<String, String[]> entry : menuData.entrySet()) {
			menubar.add(createMenu(entry.getKey(), entry.getValue()));
		}
		setJMenuBar(menubar);
	}

	public JMenu createMenu(String heading, String[] items) {
		char menuMnemonic = heading.charAt(heading.indexOf('&') + 1);
		JMenu menu = new JMenu(heading.replace("&", ""));
		menu.setMnemonic(menuMnemonic);
		for (String str : items) {
			if (str.equals("-")) {
				menu.addSeparator();
			} else {
				char mnemonic = str.charAt(str.indexOf('&') + 1);
				JMenuItem menuItem = new JMenuItem(str.replace("&", ""));
				menuItem.setMnemonic(mnemonic);
				if (shortcuts.get(str.replace("&", "")) != null) {
					menuItem.setAccelerator(shortcuts.get(str.replace("&", "")));
				}
				menu.add(menuItem);
				menuItem.addActionListener(this);
			}
		}
		return menu;
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getActionCommand().equals("Previous")) {
			int index = keys.indexOf(currentKey);
			if (index <= 0) {
				JOptionPane.showMessageDialog(this,
						"End of list reached. Cannot go further.", "Warning",
						JOptionPane.WARNING_MESSAGE);
			} else {
				index--;
				currentKey = keys.get(index);
				packageNames.setSelectedIndex(index);
			}
		}
		if (e.getActionCommand().equals("Next")) {
			int index = keys.indexOf(currentKey);
			if (index >= keys.size() - 1) {
				JOptionPane.showMessageDialog(this,
						"End of list reached. Cannot go further.", "Warning",
						JOptionPane.WARNING_MESSAGE);
			} else {
				index++;
				currentKey = keys.get(index);
				packageNames.setSelectedIndex(index);
			}
		}
		if (e.getActionCommand().equals("Exit")) {
			System.exit(0);
		}
		if (e.getActionCommand().equals("Load Database")) {
			JFileChooser fileChooser = new JFileChooser();
			int result = fileChooser.showOpenDialog(this);
			if (result == JFileChooser.APPROVE_OPTION) {
				this.packagePath = fileChooser.getSelectedFile()
						.getAbsolutePath();
				loadPackages(packagePath);
			}
		}
		if (e.getActionCommand().equals("Save Database")) {
			if (this.packagePath == null) {
				JFileChooser fileChooser = new JFileChooser();
				int result = fileChooser.showSaveDialog(this);
				if (result == JFileChooser.APPROVE_OPTION) {
					this.packagePath = fileChooser.getSelectedFile()
							.getAbsolutePath();
					savePackages(packagePath);
				}
			} else {
				savePackages(packagePath);
			}
		}
		if (e.getActionCommand().equals("Save Database As")) {
			JFileChooser fileChooser = new JFileChooser();
			int result = fileChooser.showSaveDialog(this);
			if (result == JFileChooser.APPROVE_OPTION) {
				this.packagePath = fileChooser.getSelectedFile()
						.getAbsolutePath();
				savePackages(packagePath);
			}
		}
		if (e.getActionCommand().equals("Parse Book")) {
			JFileChooser chooser = new JFileChooser();
			chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			int result = chooser.showOpenDialog(this);
			if (result == JFileChooser.APPROVE_OPTION) {
				NewBLFSParser.bookDirectory = chooser.getSelectedFile()
						.getAbsolutePath();
				try {
					final JDialog status = new JDialog(this);
					status.add(new JLabel(
							"Parsing book. This may take a while..."));
					status.setSize(400, 100);
					status.setVisible(true);
					NewBLFSParser.main(null);
					status.setVisible(false);
					JOptionPane.showMessageDialog(PackageEditor.this,
							"Parsing completed.");
					this.packages = NewBLFSParser.packages;
					refresh();
				} catch (Exception ex) {
					ex.printStackTrace();
					JOptionPane.showMessageDialog(this,
							"Exception occured while parsing the book.",
							"Error", JOptionPane.ERROR_MESSAGE);
				}
			}
		}
		if (e.getActionCommand().equals("Package Name Replacement")) {
			PackageNameReplaceDialog dialog = new PackageNameReplaceDialog();
			dialog.center(25);
			if (dialog.getResult() == 1) {
				String search = dialog.getSearchString();
				String replace = dialog.getReplaceString();

				for (Entry<String, BLFSPackage> entry : packages.entrySet()) {
					if (entry.getValue().getName().equals(search)) {
						entry.getValue().setName(replace);
					}
					for (int i = 0; i < entry.getValue().getDependencies()
							.size(); i++) {
						if (entry.getValue().getDependencies().get(i)
								.endsWith(search)) {
							entry.getValue()
									.getDependencies()
									.set(i,
											entry.getValue().getDependencies()
													.get(i)
													.replace(search, replace));
						}
					}
				}
			}
		}
		if (e.getActionCommand().equals("Search Package")) {
			PackageSearchDialog dialog = new PackageSearchDialog();
			dialog.center(30);
			if (dialog.getResult() == 1) {
				String criteria = dialog.getCriteria();
				String value = dialog.getKeywords();
				List<String> criteriaList = Arrays.asList(new String[] {
						"Name", "Dependencies", "Optional Dependencies",
						"Commands" });
				LinkedHashMap<String, BLFSPackage> searchResults = new LinkedHashMap<String, BLFSPackage>();
				for (Entry<String, BLFSPackage> entry : packages.entrySet()) {
					BLFSPackage pack = entry.getValue();
					String name = entry.getKey();
					switch (criteriaList.indexOf(criteria)) {
					case 0:
						if (pack.getName().contains(value))
							searchResults.put(name, pack);
						break;
					case 1:
						for (String dep : pack.getDependencies()) {
							if (dep.contains(value)) {
								searchResults.put(name, pack);
								break;
							}
						}
						break;
					case 2:
						for (String dep : pack.getOptionalDeps()) {
							if (dep.contains(value)) {
								searchResults.put(name, pack);
								break;
							}
						}
						break;
					case 3:
						for (UserCommand cmd : pack.getCommands()) {
							if (cmd.getCommand().contains(value)) {
								searchResults.put(name, pack);
								break;
							}
						}
						break;
					default:
						break;
					}
				}
				this.packages = searchResults;
				refresh();
			}
		}
		if (e.getActionCommand().equals("New Package")) {
			OkCancelDialog okCancelDialog = new OkCancelDialog();
			okCancelDialog.setModal(true);
			NewPackagePanel newPackagePanel = new NewPackagePanel();
			okCancelDialog.add(newPackagePanel);
			okCancelDialog.center(60);
			if (okCancelDialog.result == 1) {
				BLFSPackage pack = newPackagePanel.getPackage();
				packages.put(pack.getName(), pack);
				JOptionPane.showMessageDialog(this,
						"New package was added succesfully.");
				refresh();
			}
		}
		if (e.getActionCommand().equals("Clone Package")) {
			String packageName = JOptionPane.showInputDialog(this,
					"Enter the name of the package you want to clone");
			BLFSPackage pack = packages.get(packageName);
			BLFSPackage clonedPackage = new BLFSPackage();
			String newName = JOptionPane.showInputDialog(this,
					"Enter the new name of the package");
			clonedPackage.setName(newName);
			List<String> downloadUrls = new ArrayList<String>(pack
					.getDownloadUrls().size());
			for (String str : pack.getDownloadUrls()) {
				downloadUrls.add(str);
			}
			List<String> dependencies = new ArrayList<String>(pack
					.getDependencies().size());
			for (String str : pack.getDependencies()) {
				dependencies.add(str);
			}
			List<String> optionalDependencies = new ArrayList<String>(pack
					.getOptionalDeps().size());
			for (String str : pack.getOptionalDeps()) {
				optionalDependencies.add(str);
			}
			List<UserCommand> commands = new ArrayList<UserCommand>(pack
					.getCommands().size());
			for (UserCommand command : pack.getCommands()) {
				UserCommand cmd = new UserCommand(command.getCommand(),
						command.getExecutedBy());
				commands.add(cmd);
			}
			clonedPackage.setDownloadUrls(downloadUrls);
			clonedPackage.setCommands(commands);
			clonedPackage.setDependencies(dependencies);
			clonedPackage.setDirectoryName(pack.getDirectoryName());
			clonedPackage.setOptionalDeps(optionalDependencies);
			clonedPackage.setTarball(pack.getTarball());
			packages.put(clonedPackage.getName(), clonedPackage);
			refresh();
		}
		if (e.getActionCommand().equals("Generate Scripts")) {
			JFileChooser chooser = new JFileChooser();
			chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			int result = chooser.showSaveDialog(this);
			if (result == JFileChooser.APPROVE_OPTION) {
				File scriptsDirectory = chooser.getSelectedFile();
				try {
					int result1 = JOptionPane
							.showConfirmDialog(this,
									"Are you sure you want to generate the scripts? This would take a while.");
					if (result1 == JOptionPane.YES_OPTION) {
						ScriptGeneratorImpl generatorImpl = new ScriptGeneratorImpl();
						generatorImpl.setTemplate("script-template");
						generatorImpl.setDestination(scriptsDirectory
								.getAbsolutePath());
						for (Entry<String, BLFSPackage> entry : packages
								.entrySet()) {
							generatorImpl.generate(entry.getValue());
						}
						JOptionPane.showMessageDialog(this,
								"Scripts generation complete.");
					}
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			}
		}
		if (e.getActionCommand().equals("New Meta Package")) {
			NewMetaPackageDialog dialog = new NewMetaPackageDialog();
			dialog.setSize(50);
			dialog.showDialog(this);
			if (dialog.getResult() == 1) {
				String str = dialog.getPackageName();
				List<String> deps = dialog.getDependencies();
				BLFSPackage blfsPackage = new BLFSPackage();
				blfsPackage.setName(str);
				blfsPackage.setDependencies(deps);
				packages.put(str, blfsPackage);
				JOptionPane.showMessageDialog(this,
						"New package was added succesfully.");
				refresh();
			}
		}
		if (e.getActionCommand().equals("Reload")) {
			if (this.packagePath != null) {
				loadPackages(packagePath);
				refresh();
			}
		}
	}

	public void initMenuMap() {
		menuData.put("&Database", new String[] { "&Load Database", "&Reload",
				"&Save Database", "S&ave Database As", "-", "&Generate Scripts",
				"-", "E&xit" });
		menuData.put("&Package", new String[] { "&New Package",
				"New &Meta Package", "&Clone Package", "&Search Package" });
		menuData.put("&Options", new String[] { "&Preferences" });
		menuData.put("Pa&rser", new String[] { "&Parse Book",
				"Package Name &Replacement" });
		shortcuts.put("Load Database",
				KeyStroke.getKeyStroke(KeyEvent.VK_O, KeyEvent.CTRL_MASK));
		shortcuts.put("Save Database",
				KeyStroke.getKeyStroke(KeyEvent.VK_S, KeyEvent.CTRL_MASK));
		shortcuts.put("Search Package",
				KeyStroke.getKeyStroke(KeyEvent.VK_F, KeyEvent.CTRL_MASK));
		shortcuts.put("Reload", KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0));
	}

	public void itemStateChanged(ItemEvent e) {
		String selectedPackage = packageNames.getSelectedItem().toString();
		currentKey = selectedPackage;
		editorPanel.setPackage(packages.get(selectedPackage));
	}

	@SuppressWarnings("unchecked")
	private void loadPackages(String path) {
		try {
			ObjectInputStream inputStream = new ObjectInputStream(
					new FileInputStream(new File(path)));
			packages = (LinkedHashMap<String, BLFSPackage>) inputStream
					.readObject();
			inputStream.close();
			refresh();
		} catch (Exception ex) {
			JOptionPane.showMessageDialog(this,
					"An exception occured while loading packages.\nDetails:\n\n"
							+ ex, "Load Error", JOptionPane.ERROR_MESSAGE);
			ex.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	private void savePackages(String path) {
		try {
			boolean exists = false;
			if (new File(path).exists()) {
				exists = true;
			}
			LinkedHashMap<String, BLFSPackage> oldList = null;
			if (!exists) {
				oldList = packages;
			} else {
				ObjectInputStream objectInputStream = new ObjectInputStream(
						new FileInputStream(new File(path)));
				oldList = (LinkedHashMap<String, BLFSPackage>) objectInputStream
						.readObject();
				objectInputStream.close();

				for (Entry<String, BLFSPackage> entry : packages.entrySet()) {
					oldList.put(entry.getKey(), entry.getValue());
				}
			}
			ObjectOutputStream objectOutputStream = new ObjectOutputStream(
					new FileOutputStream(new File(path)));
			objectOutputStream.writeObject(oldList);
			objectOutputStream.close();
			JOptionPane.showMessageDialog(this,
					"Package Database was saved successfully", "Save Success",
					JOptionPane.INFORMATION_MESSAGE);
		} catch (Exception ex) {
			JOptionPane.showMessageDialog(this,
					"An exception occured while saving packages.\nDetails:\n\n"
							+ ex, "Save Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	private void refresh() {
		for (String str : packages.keySet()) {
			if (str.contains("hharfbuzz")) {
				packages.remove(str);
				break;
			}
		}
		for (String str : packages.keySet()) {
			editorPanel.setPackage(packages.get(str));
			break;
		}
		keys = new ArrayList<String>();
		packageNames.removeItemListener(this);
		packageNames.removeAllItems();
		for (String str : packages.keySet()) {
			packageNames.addItem(str);
			keys.add(str);
		}
		packageNames.addItemListener(this);
	}

	public static void main(String[] args) throws Exception {
		UIManager.put("Button.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("Label.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("TextField.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("TextArea.font", new Font("Monaco", Font.PLAIN, 13));
		UIManager.put("Menu.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("MenuBar.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("MenuItem.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("List.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("ComboBox.font", new Font("Open Sans", Font.PLAIN, 13));
		UIManager.put("Button.font", new Font("Open Sans", Font.PLAIN, 13));
		PackageEditor packageEditor = new PackageEditor();
		AppContext.masterFrame = packageEditor;
		packageEditor.setExtendedState(MAXIMIZED_BOTH);
		packageEditor.setVisible(true);
		packageEditor.setDefaultCloseOperation(EXIT_ON_CLOSE);
	}
}
