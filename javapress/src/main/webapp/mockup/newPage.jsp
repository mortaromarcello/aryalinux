<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@include file="commons/commonHeader.jsp"%>
<div class="sidebar">
	<div class="sidebarMenu">
		<%@include file="commons/mainMenu.jsp"%>
	</div>
</div>

<div class="mainContent">
	<h3>New Page</h3>
	<form method="post" action="onNewPage.jsp">
		<input type="text" name="title" class="bigTextBox" value="Enter title here" onfocus="toggler(this, 'Enter title here', 1)" onblur="toggler(this, 'Enter title here', 0)"/>
		<br/><br/>
		<textarea class="bigTextArea" onfocus="toggler(this, 'Page Content', '1')" onblur="toggler(this, 'Page Content', '0');">Page Content</textarea>
		<br/><br/>
		<input type="submit" value="Save Page" class="btn"/>
	</form>
</div>
<%@include file="commons/commonFooter.jsp"%>