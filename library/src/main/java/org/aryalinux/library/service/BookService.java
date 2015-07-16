package org.aryalinux.library.service;

import java.util.List;

import org.aryalinux.library.service.dto.BookDTO;

public interface BookService {
	List<BookDTO> getAllBooks();

	BookDTO getBookDetails(Integer id);

	List<BookDTO> getBooksIssuedByUser(String emailAddress);

	List<BookDTO> getIssuedBooks();
}
