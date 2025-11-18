<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String firstName = (String) request.getAttribute("firstName");
  String lastName = (String) request.getAttribute("lastName");
  String email = (String) request.getAttribute("email");
  String firstError = (String) request.getAttribute("firstError");
  String lastError = (String) request.getAttribute("lastError");
  String emailError = (String) request.getAttribute("emailError");
  if (firstName == null) firstName = "";
  if (lastName == null) lastName = "";
  if (email == null) email = "";
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Email List Survey</title>
  <style>
    body{ font-family: Arial, sans-serif; padding:20px }
    label{ display:block; margin:8px 0 }
    .error{ color:#b20000 }
  </style>
</head>
<body>
  <c:import url="/includes/header.html" />
  
  <h1>Survey</h1>
  <form action="${pageContext.request.contextPath}/emailList" method="post">
    <label>First Name:
      <input type="text" name="firstName" value="<%= firstName %>">
    </label>
    <div class="error"><%= firstError != null ? firstError : "" %></div>

    <label>Last Name:
      <input type="text" name="lastName" value="<%= lastName %>">
    </label>
    <div class="error"><%= lastError != null ? lastError : "" %></div>

    <label>Email:
      <input type="email" name="email" value="<%= email %>">
    </label>
    <div class="error"><%= emailError != null ? emailError : "" %></div>

    <button type="submit" name="action" value="add">Join Now</button>
    <button type="submit" name="action" value="return">Return</button>
  </form>
  
  <c:import url="/includes/footer.jsp" />
</body>
</html>
