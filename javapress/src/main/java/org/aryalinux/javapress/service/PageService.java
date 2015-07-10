package org.aryalinux.javapress.service;

import java.util.List;

import org.aryalinux.javapress.service.dto.PageDTO;

public interface PageService {
	List<PageDTO> getPages();

	void savePage(PageDTO pageRequest);
}
