# ----------- Build Stage -----------
FROM maven:3.9.5-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY src ./src

# Preload dependencies and build
RUN mvn dependency:go-offline -B
RUN mvn clean package -DskipTests

# ----------- Run Stage -----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar cabse.jar

EXPOSE 8080

ENTRYPOINT ["java", "-Xms128m", "-XX:+UseSerialGC",  "-jar", "cabse.jar"]
