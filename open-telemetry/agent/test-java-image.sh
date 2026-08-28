#!/bin/sh

set -eu

if [ "$#" -ne 6 ]; then
    echo "usage: $0 <image> <otel-version> <java-major-version> <java-kind> <variant> <max-size-bytes>" >&2
    exit 2
fi

image=$1
otel_version=$2
java_major_version=$3
java_kind=$4
variant=$5
max_size_bytes=$6

case "$java_kind" in
    jdk|jre) ;;
    *)
        echo "unsupported Java kind: $java_kind" >&2
        exit 2
        ;;
esac

case "$variant" in
    plain|alpine|ffmpeg|tomcat) ;;
    *)
        echo "unsupported variant: $variant" >&2
        exit 2
        ;;
esac

if ! output=$(docker run --rm -e OTEL_SDK_DISABLED=true "$image" sh -c '
    set -eu

    java -version
    java -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -version

    if [ "'"$java_kind"'" = jdk ]; then
        javac -version
    elif command -v javac >/dev/null 2>&1; then
        echo "javac must not be installed in a JRE image" >&2
        exit 1
    fi

    if command -v dpkg-query >/dev/null 2>&1; then
        for package in build-essential curl gcc g++ make linux-libc-dev libasound2-dev libssl-dev wget; do
            if dpkg-query -W -f="\${Status}\n" "$package" 2>/dev/null | grep -qx "install ok installed"; then
                echo "forbidden package is installed: $package" >&2
                exit 1
            fi
        done
    fi

    if command -v apk >/dev/null 2>&1; then
        for package in build-base curl gcc g++ make linux-headers musl-dev openssl-dev; do
            if apk info -e "$package" >/dev/null 2>&1; then
                echo "forbidden package is installed: $package" >&2
                exit 1
            fi
        done
    fi

    if [ "'"$variant"'" = tomcat ]; then
        catalina.sh version
    fi
' 2>&1); then
    printf '%s\n' "$output" >&2
    exit 1
fi

printf '%s\n' "$output"

if ! printf '%s\n' "$output" | grep --fixed-strings "openjdk version \"${java_major_version}." >/dev/null; then
    echo "expected Java ${java_major_version} in $image" >&2
    exit 1
fi

if [ "$java_kind" = jdk ] \
    && ! printf '%s\n' "$output" | grep --fixed-strings "javac ${java_major_version}." >/dev/null; then
    echo "expected javac ${java_major_version} in $image" >&2
    exit 1
fi

if ! printf '%s\n' "$output" | grep --fixed-strings "opentelemetry-javaagent - version: ${otel_version}" >/dev/null; then
    echo "expected OpenTelemetry Java Agent ${otel_version} in $image" >&2
    exit 1
fi

if [ "$variant" = ffmpeg ]; then
    docker run --rm "$image" sh -c '
        set -eu
        ffmpeg -version
        ffprobe -version
        ffmpeg -hide_banner -encoders 2>/dev/null | grep --fixed-strings libmp3lame
    '
elif docker run --rm "$image" sh -c 'command -v ffmpeg >/dev/null 2>&1'; then
    echo "ffmpeg must not be installed in $variant image" >&2
    exit 1
fi

image_size_bytes=$(docker image inspect --format '{{.Size}}' "$image")
if [ "$image_size_bytes" -gt "$max_size_bytes" ]; then
    echo "image exceeds size limit: $image_size_bytes > $max_size_bytes bytes" >&2
    exit 1
fi

printf 'image size: %s bytes (limit: %s bytes)\n' "$image_size_bytes" "$max_size_bytes"
