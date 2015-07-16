package org.aryalinux.library.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.aryalinux.library.data.dao.BaseDAO;
import org.aryalinux.library.data.entities.Book;
import org.aryalinux.library.service.dto.BookDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BookServiceImpl implements BookService {
	@Autowired
	private BaseDAO<Book> bookDAO;

	public BookDTO getBookDetails(Integer id) {
		Book book = bookDAO.get(id);
		return convert(book);
	}

	public List<BookDTO> getAllBooks() {
		List<Book> books = bookDAO.list();
		List<BookDTO> bookDTOs = new ArrayList<BookDTO>();
		for (Book book : books) {
			bookDTOs.add(convert(book));
		}
		return bookDTOs;
	}

	public List<BookDTO> getBooksIssuedByUser(String emailAddress) {
		Map<String, Object> criteria = new LinkedHashMap<String, Object>();
		criteria.put("user.email", emailAddress);
		List<Book> books = bookDAO.list(criteria);
		List<BookDTO> bookDTOs = new ArrayList<BookDTO>();
		for (Book book : books) {
			bookDTOs.add(convert(book));
		}
		return bookDTOs;
	}

	public List<BookDTO> getIssuedBooks() {
		// TODO Auto-generated method stub
		return null;
	}

	private BookDTO convert(Book book) {
		BookDTO bookDTO = new BookDTO();
		bookDTO.setId(book.getId());
		bookDTO.setName(book.getName());
		bookDTO.setAuthor(book.getAuthor());
		bookDTO.setCategory(book.getCategory().getName());
		bookDTO.setPublisher(book.getPublisher());
		bookDTO.setPrice(book.getPrice());
		return bookDTO;
	}
}
