# Maven build container 

FROM maven:3.8.5-openjdk-17 AS maven_build

COPY pom.xml /app/

COPY src /app/src/

WORKDIR /app/

RUN mvn package

#pull base image

FROM eclipse-temurin:17

#expose port 8080
EXPOSE 8080

#default command
CMD java -jar /app/spring-docker.jar

COPY --from=maven_build /app/target/spring-docker.jar /app/spring-docker.jar
