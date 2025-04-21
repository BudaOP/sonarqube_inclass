FROM maven:latest

LABEL authors="ibudaa"

WORKDIR /app

COPY pom.xml /app/

COPY . /app/

RUN mvn package

CMD ["java", "-jar", "target/app.jar"]
