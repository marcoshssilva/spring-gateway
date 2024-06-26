FROM maven:3.9.5-eclipse-temurin-17-focal AS builder
WORKDIR /build

COPY pom.xml /build/pom.xml
RUN mvn dependency:go-offline

COPY src /build/src
RUN mvn install

FROM eclipse-temurin:17-jre-focal AS java
COPY --from=builder /build/target/spring-cloud-gateway-*.jar app.jar
ENTRYPOINT java -XX:+UseContainerSupport -XX:MaxRAMPercentage=80 $JAVA_OPTS -jar app.jar

EXPOSE 8080