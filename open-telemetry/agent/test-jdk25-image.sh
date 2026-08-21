#!/bin/sh

set -eu

if [ "$#" -ne 3 ]; then
    echo "usage: $0 <image> <java-major-version> <otel-version>" >&2
    exit 2
fi

image=$1
java_major_version=$2
otel_version=$3
if ! output=$(docker run --rm "$image" sh -c '
    java -version
    java -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -version
' 2>&1); then
    printf '%s\n' "$output" >&2
    exit 1
fi

printf '%s\n' "$output"

if ! printf '%s\n' "$output" | grep --fixed-strings "openjdk version \"${java_major_version}." >/dev/null; then
    echo "expected JDK ${java_major_version} in $image" >&2
    exit 1
fi

if ! printf '%s\n' "$output" | grep --fixed-strings "opentelemetry-javaagent - version: ${otel_version}" >/dev/null; then
    echo "expected OpenTelemetry Java Agent ${otel_version} in $image" >&2
    exit 1
fi
