FROM openjdk:11 AS BUILD_IMAGE
RUN apt update && apt install -y maven
COPY pom.xml ./
COPY src ./src
RUN mvn clean install

FROM tomcat:9-jre11
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE target/*.war /usr/local/tomcat/webapps/java-sample.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
