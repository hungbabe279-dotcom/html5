package com.example.emaillist;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "EmailListServlet", urlPatterns = {"/emailList"})
public class EmailListServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";

        if ("add".equals(action)) {
            String first = safe(req.getParameter("firstName"));
            String last = safe(req.getParameter("lastName"));
            String email = safe(req.getParameter("email"));

            boolean hasError = false;
            if (first.isEmpty()) {
                req.setAttribute("firstError", "First name is required.");
                hasError = true;
            }
            if (last.isEmpty()) {
                req.setAttribute("lastError", "Last name is required.");
                hasError = true;
            }
            if (email.isEmpty()) {
                req.setAttribute("emailError", "Email is required.");
                hasError = true;
            } else if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                req.setAttribute("emailError", "Please enter a valid email address.");
                hasError = true;
            }

            if (hasError) {
                req.setAttribute("firstName", first);
                req.setAttribute("lastName", last);
                req.setAttribute("email", email);
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            synchronized (getServletContext()) {
                List<String> list = (List<String>) getServletContext().getAttribute("emailList");
                if (list == null) {
                    list = new ArrayList<>();
                    getServletContext().setAttribute("emailList", list);
                }
                list.add(email);
            }

            req.setAttribute("firstName", first);
            req.setAttribute("lastName", last);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/thanks.jsp").forward(req, resp);

        } else if ("return".equals(action)) {
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    // Intentionally do not implement doGet to cause 405 on GET requests

    private String safe(String s) { return s == null ? "" : s.trim(); }
}
