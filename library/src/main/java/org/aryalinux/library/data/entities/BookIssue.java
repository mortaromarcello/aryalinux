package org.aryalinux.library.data.entities;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "book_issue")
public class BookIssue extends BaseEntity {
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "bookId")
	private Book book;
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name="userEmail")
	private User user;

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

}
