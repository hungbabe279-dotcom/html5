<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String firstName = (String) request.getAttribute("firstName");
  String lastName = (String) request.getAttribute("lastName");
  String email = (String) request.getAttribute("email");
  if (firstName == null) firstName = "";
  if (lastName == null) lastName = "";
  if (email == null) email = "";
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Thank you</title>
  <style>body{ font-family: Arial, sans-serif; padding:20px }</style>
</head>
<body>
  <c:import url="/includes/header.html" />
  
  <h2>Thank you!</h2>
  <p>We received your submission.</p>
  <p>Name: <%= firstName %> <%= lastName %></p>
  <p>Email: <%= email %></p>
  <form action="${pageContext.request.contextPath}/emailList" method="post">
    <button type="submit" name="action" value="return">Return</button>
  </form>
  
  <c:import url="/includes/footer.jsp" />
</body>
</html>
