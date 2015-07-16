package org.aryalinux.library.rest;

import java.util.List;

import org.aryalinux.library.service.BookService;
import org.aryalinux.library.service.dto.BookDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Component
public class BookController {
	@Autowired
	BookService bookService;

	@RequestMapping(value = "/services/books", method = RequestMethod.GET)
	@ResponseBody
	public List<BookDTO> getBooks() {
		return bookService.getAllBooks();
	}
}
