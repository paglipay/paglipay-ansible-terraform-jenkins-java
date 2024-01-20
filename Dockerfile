# FROM ubuntu:latest

# # Install Java.
# RUN apt-get update && apt-get install -y openjdk-8-jdk maven

# WORKDIR /app

# COPY spring-demo /app
# RUN mvn clean package

# EXPOSE 5000
# CMD ["java", "-jar", "target/java-getting-started-1.0.war"]

FROM tomcat:10

# ADD java-getting-started.war /usr/local/tomcat/webapps/

# EXPOSE 8080

# CMD ["catalina.sh", "run"]

# FROM maven:3.6.3 as maven
# LABEL COMPANY="ShuttleOps"
# LABEL MAINTAINER="support@shuttleops.com"
# LABEL APPLICATION="Sample Application"

# WORKDIR /usr/src/app
# COPY ./spring-demo /usr/src/app
# RUN mvn package 

# FROM tomcat:8.5-jdk15-openjdk-oracle
ARG TOMCAT_FILE_PATH=/docker 
	
#Data & Config - Persistent Mount Point
# ENV APP_DATA_FOLDER=/var/lib/SampleApp
# ENV SAMPLE_APP_CONFIG=${APP_DATA_FOLDER}/config/
	
# ENV CATALINA_OPTS="-Xms1024m -Xmx4096m -XX:MetaspaceSize=512m -	XX:MaxMetaspaceSize=512m -Xss512k"

#Move over the War file from previous build step
WORKDIR /usr/local/tomcat/webapps/
# COPY --from=maven /usr/src/app/target/SampleApp.war /usr/local/tomcat/webapps/api.war
COPY java-getting-started.war /usr/local/tomcat/webapps/api.war

# COPY ${TOMCAT_FILE_PATH}/* ${CATALINA_HOME}/conf/

# WORKDIR $APP_DATA_FOLDER

EXPOSE 8080
ENTRYPOINT ["catalina.sh", "run"]