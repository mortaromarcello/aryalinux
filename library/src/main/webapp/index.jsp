<%@page import="org.aryalinux.library.misc.LibraryContext"%>
<%@page
	import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="org.aryalinux.library.data.entities.User"%>
<%@page import="java.util.List"%>
<%@page import="org.aryalinux.library.data.dao.UserDAO"%>
<%@page
	import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@page language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		ApplicationContext applicationContext = LibraryContext
				.getApplicationContext();
		UserDAO dao = (UserDAO) applicationContext.getBean(UserDAO.class);
		List<User> users = dao.list();
		out.println(users);
	%>
</body>
</html>