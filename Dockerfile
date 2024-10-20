# Phase 1 - Generate classes with mvn;
FROM maven:3.9-eclipse-temurin-17-alpine AS sca
WORKDIR /petclinic
COPY pom.xml .
COPY mvnw .
COPY .mvn/ ./.mvn/
COPY src/ ./src/
RUN mvn clean test sonar:sonar -Dsonar.organization=johnbrycestudent -Dsonar.projectKey=johnbrycestudent_springpetclinic -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=de56d5cff426ca1d81003e22c435aeaaeb4d8880

# Phase 2 - Build artifact;
FROM maven:3.9-eclipse-temurin-17-alpine AS build
WORKDIR /petclinic
COPY --from=sca /petclinic/pom.xml .
COPY --from=sca /petclinic/mvnw .
COPY --from=sca /petclinic/.mvn/ ./.mvn/
COPY --from=sca /petclinic/src/ ./src/
RUN ./mvnw package

# Phase 3 - Create deployable image;
FROM openjdk:17-jdk-alpine3.14 AS deploy
WORKDIR /code
COPY --from=build /petclinic/target/*.jar .
EXPOSE 8080
RUN ls
CMD java -jar *.jar
