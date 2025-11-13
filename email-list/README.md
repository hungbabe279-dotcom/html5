Email List Servlet example

This is a simple Java Servlet + JSP example implementing the exercise requirements.

To build and run locally:

How to run
----------

Option A — Docker (recommended)

1. Install Docker Desktop for Windows and start it.
2. From this folder, run the `run-email-list.ps1` helper script in PowerShell:

```powershell
cd "C:\Users\damin\OneDrive\New folder\DTDM\email-list"
.\run-email-list.ps1
```

Add `-NoCleanup` to the script if you want to leave the container running for manual inspection:

```powershell
.\run-email-list.ps1 -NoCleanup
```

Option B — Maven

1. Install JDK and Maven.
2. From this folder run:

```powershell
mvn tomcat7:run
# or
mvn package -DskipTests
# then deploy target/*.war to your Tomcat server (rename to ROOT.war to serve at /)
```

Notes
- If port 8080 is already in use, change the host-side port when running Docker (for example `-p 9090:8080`).
- If Docker build or run fails, copy the terminal output and paste it here and I'll help diagnose.


Notes:
- The servlet implements only doPost; GET requests to `/emailList` will return 405 (method not allowed).
- The form uses POST so parameters are not visible in URL.
