ARG SPARK_VERSION=3.5.7-scala2.12-java17
FROM maven:3.9.12-eclipse-temurin-17 as deps

WORKDIR /build

COPY pom.xml .

RUN --mount=type=cache,target=/root/.m2 \
    mvn -B dependency:go-offline && \
    mvn -B dependency:copy-dependencies -DoutputDirectory=/dependencies/jars -DincludeScope=runtime

FROM spark:${SPARK_VERSION}

USER root
WORKDIR ${SPARK_HOME}/jars
COPY --from=deps /dependencies/jars/*.jar ./

COPY entrypoint.sh /opt/spark/entrypoint.sh
RUN chmod +x /opt/spark/entrypoint.sh
USER spark
WORKDIR ${SPARK_HOME}
ENTRYPOINT ["/opt/spark/entrypoint.sh"]
