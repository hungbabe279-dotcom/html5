# Multi-stage build for Java Servlet app
# Stage 1: Build with Maven
FROM maven:3.8-openjdk-8 AS builder
WORKDIR /app
COPY email-list/pom.xml ./pom.xml
COPY email-list/src ./src
RUN mvn clean package -DskipTests -q

# Stage 2: Run on Tomcat
FROM tomcat:9-jre8
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
# start command
CMD ["npm", "start"]
