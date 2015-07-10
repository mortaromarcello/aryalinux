<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@include file="commons/loginHeader.jsp"%>

<div class="loginDiv">
	<form method="POST" action="home.jsp">
		<div class="label">Username</div>
		<div class="control">
			<input name="username" class="textfield" />
		</div>
		<div class="label">Password</div>
		<div class="control">
			<input name="password" class="textfield" type="password" />
		</div>
		<div class="control">
			<input type="submit" value="Login" class="btn"/>
		</div>
		<a href="#">Forgot Password?</a>
	</form>
</div>
<%@include file="commons/loginFooter.jsp"%>