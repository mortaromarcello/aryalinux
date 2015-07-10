package org.aryalinux.javapress.service.impl;

import java.util.List;

import org.aryalinux.javapress.data.dao.PageDAO;
import org.aryalinux.javapress.data.entities.Page;
import org.aryalinux.javapress.service.PageService;
import org.aryalinux.javapress.service.dto.PageDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PageServiceImpl implements PageService {
	@Autowired
	private PageDAO pageDAO;

	public List<PageDTO> getPages() {
		List<Page> pages = pageDAO.getPages();
		
	}

	public void savePage(PageDTO pageRequest) {
		// TODO Auto-generated method stub

	}

}
