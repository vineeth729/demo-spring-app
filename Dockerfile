# Build stage - using current official Maven image
FROM public.ecr.aws/docker/library/maven:3.8.7-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src /app/src
RUN mvn package -DskipTests

# Run stage - using official Eclipse Temurin JDK
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17
WORKDIR /app
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
