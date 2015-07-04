package org.aryalinux.parser.ui.blfs;

public interface ListItemEditor<E> extends ItemEditor {
	public E showEditor(E item) throws Exception;
}
