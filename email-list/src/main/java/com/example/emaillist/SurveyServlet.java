package com.example.emaillist;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SurveyServlet", urlPatterns = {"/survey"})
public class SurveyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set current year for footer
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        req.setAttribute("currentYear", currentYear);

        String firstName = safe(req.getParameter("firstName"));
        String lastName = safe(req.getParameter("lastName"));
        String email = safe(req.getParameter("email"));
        String heardFrom = safe(req.getParameter("heardFrom"));
        String updates = safe(req.getParameter("updates"));
        String contactVia = safe(req.getParameter("contactVia"));

        // Create User object
        User user = new User(email, firstName, lastName, heardFrom, updates, contactVia);
        req.setAttribute("user", user);

        // Forward to survey.jsp
        req.getRequestDispatcher("/survey.jsp").forward(req, resp);
    }

    private String safe(String s) {
        return s == null ? "" : s.trim();
    }
}
