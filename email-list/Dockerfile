# Multi-stage Dockerfile: build with Maven, run on Tomcat
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build

# copy pom and sources
COPY pom.xml .
COPY src ./src

# build war
RUN mvn -DskipTests package

FROM tomcat:9.0-jdk17

# Remove default webapps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR to Tomcat as ROOT so app is served at /
COPY --from=builder /build/target/email-list.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
