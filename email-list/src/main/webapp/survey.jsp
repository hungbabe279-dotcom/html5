<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Survey Results</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px }
    table { border-collapse: collapse; margin: 20px 0 }
    td { border: 1px solid #ccc; padding: 10px }
  </style>
</head>
<body>
  <h1>Thanks for taking our survey!</h1>
  <p>Here is the information that you entered:</p>
  
  <table>
    <tr>
      <td><strong>Email:</strong></td>
      <td><c:out value="${user.email}" /></td>
    </tr>
    <tr>
      <td><strong>First Name:</strong></td>
      <td><c:out value="${user.firstName}" /></td>
    </tr>
    <tr>
      <td><strong>Last Name:</strong></td>
      <td><c:out value="${user.lastName}" /></td>
    </tr>
    <tr>
      <td><strong>Heard From:</strong></td>
      <td><c:out value="${user.heardFrom}" /></td>
    </tr>
    <tr>
      <td><strong>Updates:</strong></td>
      <td><c:out value="${user.updates}" /></td>
    </tr>
    
    <!-- Show Contact Via only if user wants updates -->
    <c:if test="${user.updates == 'Yes'}">
      <tr>
        <td><strong>Contact Via:</strong></td>
        <td><c:out value="${user.contactVia}" /></td>
      </tr>
    </c:if>
  </table>
  
  <form action="${pageContext.request.contextPath}/survey" method="post">
    <button type="submit">Return</button>
  </form>
</body>
</html>
