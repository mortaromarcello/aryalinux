package org.aryalinux.javapress.service.converter;

import org.aryalinux.javapress.data.entities.Page;
import org.aryalinux.javapress.service.dto.PageDTO;

public class PageConverter extends Converter<Page, PageDTO> {

	@Override
	public PageDTO convert(Page ref) {
		PageDTO dto = new PageDTO();
		dto.setPageTitle(ref.getTitle());
		dto.setPageContents(ref.getBody());
		return dto;
	}

	@Override
	public Page convertBack(PageDTO ref) {
		// TODO Auto-generated method stub
		return null;
	}

}
