package org.aryalinux.javapress.data.dao;

import java.util.List;

import org.aryalinux.javapress.data.entities.Page;

public interface PageDAO {
	public void save(Page page);

	public void delete(Page page);

	public void update(Page page);

	public List<Page> getPages();
}
