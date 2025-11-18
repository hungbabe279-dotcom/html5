Email List Servlet example

This is a simple Java Servlet + JSP example implementing the exercise requirements.

To build and run locally:

1. Install Maven and a servlet container (Tomcat) or use the embedded servlet plugin.
2. From this directory run:

   mvn package

3. Deploy the generated `target/email-list.war` to Tomcat's `webapps` folder.
4. Open `http://localhost:8080/email-list/` and test the form.

Notes:
- The servlet implements only doPost; GET requests to `/emailList` will return 405 (method not allowed).
- The form uses POST so parameters are not visible in URL.
