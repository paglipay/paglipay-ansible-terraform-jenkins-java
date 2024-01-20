FROM ubuntu:latest

# Install Java.
RUN apt-get update && apt-get install -y openjdk-8-jdk maven

WORKDIR /app

COPY spring-demo /app
RUN mvn clean package

EXPOSE 5000
CMD ["java", "-jar", "target/java-getting-started-1.0.war"]