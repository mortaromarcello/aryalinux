package org.aryalinux.library.service.dto;

public class BookIssueDTO {
	private Integer id;
	private String issuerEmailAddress;
	private Integer bookId;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getIssuerEmailAddress() {
		return issuerEmailAddress;
	}

	public void setIssuerEmailAddress(String issuerEmailAddress) {
		this.issuerEmailAddress = issuerEmailAddress;
	}

	public Integer getBookId() {
		return bookId;
	}

	public void setBookId(Integer bookId) {
		this.bookId = bookId;
	}

}
