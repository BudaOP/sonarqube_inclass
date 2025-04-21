FROM maven:latest

LABEL author="ibudaa"

WORKDIR /app

COPY . .

RUN mvn clean package

CMD ["java", "-jar", "target/demo-1.0-SNAPSHOT.jar"]
