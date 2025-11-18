package com.example.emaillist;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;
import java.io.File;

public class EmbeddedServer {
    public static void main(String[] args) throws Exception {
        // Create Jetty server on port 8080
        Server server = new Server(8080);
        
        // Create web app context
        WebAppContext webapp = new WebAppContext();
        webapp.setContextPath("/");
        
        // Set resource base to webapp directory
        File webappDir = new File("src/main/webapp");
        if (!webappDir.exists()) {
            System.err.println("ERROR: src/main/webapp directory not found!");
            System.exit(1);
        }
        webapp.setResourceBase(webappDir.getAbsolutePath());
        
        // Add servlet handler
        server.setHandler(webapp);
        
        // Start server
        server.start();
        System.out.println("========================================");
        System.out.println("Server started on http://localhost:8080/");
        System.out.println("========================================");
        System.out.println("\nAccess:");
        System.out.println("  - Welcome: http://localhost:8080/welcome.html");
        System.out.println("  - Email List: http://localhost:8080/index.jsp");
        System.out.println("  - Survey: http://localhost:8080/survey-form.html");
        System.out.println("\nPress Ctrl+C to stop...\n");
        
        server.join();
    }
}
