FROM eclipse-temurin:17-jre-focal AS java
FROM maven:3.9.5-eclipse-temurin-17-focal AS maven

FROM maven AS builder
WORKDIR /build

COPY pom.xml /build/pom.xml
RUN mvn dependency:go-offline

COPY src /build/src
RUN mvn -DskipTests install
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar /build/opentelemetry-javaagent.jar

FROM java AS RUNNER
USER root
WORKDIR /app

COPY --from=builder --chmod=644 --chown=root:root /build/opentelemetry-javaagent.jar opentelemetry-javaagent.jar
COPY --from=builder --chmod=644 --chown=root:root /build/target/spring-cloud-gateway-*.jar app.jar

USER 1001

ARG OTEL_LOGS_EXPORTER
ARG OTEL_EXPORTER_OTLP_ENDPOINT
ARG OTEL_SERVICE_NAME
ARG JAVA_VM_OPTIONS
ARG PORT
ARG MANAGEMENT_PORT

ENV JAVA_VM_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=80 -javaagent:/app/opentelemetry-javaagent.jar"
ENV OTEL_LOGS_EXPORTER="otlp"
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318"
ENV OTEL_SERVICE_NAME="spring-cloud-apigateway-discoverylocator"
ENV PORT="8080"
ENV MANAGEMENT_PORT="8080"

ENTRYPOINT ["sh", "-c"]
CMD ["exec java $JAVA_VM_OPTIONS -jar /app/app.jar"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD sh -c "wget --no-verbose --tries=1 --spider http://localhost:$MANAGEMENT_PORT/actuator/health || exit 1"

EXPOSE 8080

LABEL authors="Marcos Henrique de Santana"