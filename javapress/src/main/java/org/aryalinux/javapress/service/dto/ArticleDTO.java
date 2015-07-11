package org.aryalinux.javapress.service.dto;

import java.util.Date;
import java.util.List;

import org.aryalinux.javapress.data.entities.Category;
import org.aryalinux.javapress.data.entities.User;

public class ArticleDTO {
	private String title;
	private String body;
	private Date lastUpdatedDate;
	private User lastUpdatedBy;
	private Category category;
	private List<CommentDTO> comments;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public Date getLastUpdatedDate() {
		return lastUpdatedDate;
	}

	public void setLastUpdatedDate(Date lastUpdatedDate) {
		this.lastUpdatedDate = lastUpdatedDate;
	}

	public User getLastUpdatedBy() {
		return lastUpdatedBy;
	}

	public void setLastUpdatedBy(User lastUpdatedBy) {
		this.lastUpdatedBy = lastUpdatedBy;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public List<CommentDTO> getCommentDTOs() {
		return comments;
	}

	public void setCommentDTOs(List<CommentDTO> comments) {
		this.comments = comments;
	}

}
