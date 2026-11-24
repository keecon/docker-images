ARG JAVA_BASE_TAG=debian:13-slim
FROM ${JAVA_BASE_TAG}

ARG JAVA_BASE_TAG
ARG JAVA_MAJOR
ARG JAVA_KIND
ARG TEMURIN_VERSION
ARG OTEL_VERSION
ARG OTEL_SHA256
ARG OTEL_INSTALL_URL=https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_VERSION}/opentelemetry-javaagent.jar
ARG ADOPTIUM_KEY_URL=https://packages.adoptium.net/artifactory/api/gpg/key/public

LABEL org.opencontainers.image.source=https://github.com/keecon/docker-images
LABEL org.opencontainers.image.version=${OTEL_VERSION}
LABEL org.opencontainers.image.base.name=${JAVA_BASE_TAG}

ENV LANG=C.UTF-8

# Same JDK source as gcr.io/distroless/java*-debian13: Temurin from the Adoptium Debian repository.
# TEMURIN_VERSION uses the Docker tag form (25.0.5.1_2); the .deb version is 25.0.5.1.0+2-0.
RUN test -n "${JAVA_MAJOR}" \
    && test -n "${JAVA_KIND}" \
    && test -n "${TEMURIN_VERSION}" \
    && test -n "${OTEL_VERSION}" \
    && test -n "${OTEL_SHA256}" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl \
    && install -d -m 0755 /etc/apt/keyrings \
    && curl --fail --show-error --silent --location --retry 3 \
        "${ADOPTIUM_KEY_URL}" --output /etc/apt/keyrings/adoptium.asc \
    && echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo "${VERSION_CODENAME}") main" \
        > /etc/apt/sources.list.d/adoptium.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        "temurin-${JAVA_MAJOR}-${JAVA_KIND}=${TEMURIN_VERSION%_*}.0+${TEMURIN_VERSION#*_}-0" \
    && install -d -m 0755 /otel \
    && curl --fail --show-error --silent --location --retry 3 \
        "${OTEL_INSTALL_URL}" \
        --output /otel/opentelemetry-javaagent.jar \
    && echo "${OTEL_SHA256}  /otel/opentelemetry-javaagent.jar" | sha256sum --check \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

# Default user is root; the nonroot user (same uid/gid as distroless) is available via USER nonroot or --user 65532.
RUN groupadd --gid 65532 nonroot \
    && useradd --uid 65532 --gid 65532 --create-home --home-dir /home/nonroot --shell /usr/sbin/nologin nonroot

RUN java -version \
    && if command -v javac >/dev/null 2>&1; then javac -version; fi \
    && OTEL_SDK_DISABLED=true java -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -version
