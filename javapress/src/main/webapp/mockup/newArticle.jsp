<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@include file="commons/commonHeader.jsp"%>
<div class="sidebar">
	<div class="sidebarMenu">
		<%@include file="commons/mainMenu.jsp"%>
	</div>
</div>

<div class="mainContent">
	<h3>New Article</h3>
	<form method="post" action="onNewArticle.jsp">
		<input type="text" name="title" class="bigTextBox" value="Enter heading for article here" onfocus="toggler(this, 'Enter heading for article here', 1)" onblur="toggler(this, 'Enter heading for article here', 0)"/>
		<br/><br/>
		<textarea class="bigTextArea" onfocus="toggler(this, 'Enter content for the article here', '1')" onblur="toggler(this, 'Enter content for the article here', '0');">Enter content for the article here</textarea>
		<br/><br/>
		<input type="submit" value="Save Page" class="btn"/>
	</form>
</div>
<div class="rightSidebar">
	<br/><br/>
	<div class="label">Page where this article goes.</div>
	<select></select>
	<div class="label">Order inside the page</div>
	<select></select>
	<div class="label">Show Date</div>
	<div class="control"><input type="radio" name="showDate"> Yes <input type="radio" name="showDate" checked="checked"> No</div>
	<div class="label">This article must be signed</div>
	<div class="control"><input type="radio" name="signed"> Yes <input type="radio" name="signed" checked="checked"> No</div>
	<div class="label">Allow comments on this article</div>
	<div class="control"><input type="radio" name="comments"> Yes <input type="radio" name="comments" checked="checked"> No</div>
</div>
<%@include file="commons/commonFooter.jsp"%>