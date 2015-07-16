package org.aryalinux.library.data.dao.impl;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.aryalinux.library.data.dao.BookDAO;
import org.aryalinux.library.data.entities.Book;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BookDAOImpl implements BookDAO {
	@Autowired
	private BaseDAOImpl<Book> baseDAOImpl;

	public void save(Book ref) {
		baseDAOImpl.save(ref);
	}

	public void udpate(Book ref) {
		baseDAOImpl.udpate(ref);
	}

	public void delete(Book ref) {
		baseDAOImpl.delete(ref);
	}

	public List<Book> list() {
		return baseDAOImpl.list();
	}

	public Book get(Serializable id) {
		return baseDAOImpl.get(id);
	}

	public List<Book> list(Map<String, Object> filters) {
		return baseDAOImpl.list(filters);
	}

}
