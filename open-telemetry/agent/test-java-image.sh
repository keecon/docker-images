#!/bin/sh

set -eu

if [ "$#" -ne 5 ]; then
    echo "usage: $0 <image> <otel-version> <java-major-version> <java-kind> <variant>" >&2
    exit 2
fi

image=$1
otel_version=$2
java_major_version=$3
java_kind=$4
variant=$5

case "$java_kind" in
    jdk|jre) ;;
    *)
        echo "unsupported Java kind: $java_kind" >&2
        exit 2
        ;;
esac

case "$variant" in
    plain|distroless|distroless-ffmpeg) ;;
    *)
        echo "unsupported variant: $variant" >&2
        exit 2
        ;;
esac

# A missing base-image platform can silently fall back to another arch (e.g. arm/v7 for arm64).
case "${DOCKER_DEFAULT_PLATFORM:-linux/amd64}" in
    linux/amd64) expected_arch=amd64 ;;
    linux/arm64) expected_arch=aarch64 ;;
    *) echo "unsupported platform: ${DOCKER_DEFAULT_PLATFORM}" >&2; exit 2 ;;
esac
actual_arch=$(docker run --rm --entrypoint java "$image" -XshowSettings:properties -version 2>&1 \
    | sed -n 's/^ *os\.arch = //p')
if [ "$actual_arch" != "$expected_arch" ]; then
    echo "expected os.arch $expected_arch but got '$actual_arch' in $image" >&2
    exit 1
fi

# User policy: the default user is root, and a nonroot user (65532) must exist and be usable.
configured_user=$(docker image inspect --format '{{.Config.User}}' "$image")
case "$configured_user" in
    ''|0|root|0:0|root:root) ;;
    *) echo "expected default user root but got '$configured_user' in $image" >&2; exit 1 ;;
esac
container=$(docker create "$image")
passwd_entry=$(docker cp "$container:/etc/passwd" - | tar -xOf - | grep '^nonroot:' || true)
docker rm "$container" >/dev/null
if [ "${passwd_entry%%:*}:$(printf '%s' "$passwd_entry" | cut -d: -f3,4)" != nonroot:65532:65532 ]; then
    echo "expected nonroot user 65532:65532 in $image, got '$passwd_entry'" >&2
    exit 1
fi
nonroot_output=$(docker run --rm --user nonroot --entrypoint java -e OTEL_SDK_DISABLED=true "$image" \
    -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -version 2>&1) || {
    printf '%s\n' "$nonroot_output" >&2
    echo "java with the OpenTelemetry agent must run as nonroot in $image" >&2
    exit 1
}
printf '%s\n' "$nonroot_output" | grep --fixed-strings "opentelemetry-javaagent - version: ${otel_version}" >/dev/null

if [ "$variant" = distroless ] || [ "$variant" = distroless-ffmpeg ]; then
    output=$(docker run --rm --entrypoint java -e OTEL_SDK_DISABLED=true "$image" \
        -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -version 2>&1) || {
        printf '%s\n' "$output" >&2
        exit 1
    }
    printf '%s\n' "$output"
    printf '%s\n' "$output" | grep --fixed-strings "openjdk version \"${java_major_version}." >/dev/null
    printf '%s\n' "$output" | grep --fixed-strings "opentelemetry-javaagent - version: ${otel_version}" >/dev/null
    if [ "$variant" = distroless-ffmpeg ]; then
        test_dir=$(mktemp -d)
        trap 'rm -f "$test_dir/TestDistrolessFFmpeg.class"; rmdir "$test_dir"' EXIT
        chmod 755 "$test_dir"
        javac --release 17 -d "$test_dir" "$(dirname "$0")/TestDistrolessFFmpeg.java"
        docker run --rm --network none --user 65532:65532 -e OTEL_SDK_DISABLED=true \
            -v "$test_dir:/check:ro" --entrypoint java "$image" \
            -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -cp /check TestDistrolessFFmpeg
    fi
    exit 0
fi

if ! output=$(docker run --rm -e OTEL_SDK_DISABLED=true "$image" sh -c '
    set -eu

    java -version
    java -Xshare:off -javaagent:/otel/opentelemetry-javaagent.jar -version

    if [ "'"$variant"'" = plain ]; then
        . /etc/os-release
        if [ "$ID" != debian ] || [ "$VERSION_ID" != 13 ]; then
            echo "expected Debian 13 in the default image" >&2
            exit 1
        fi
        if [ "${LANG:-}" != C.UTF-8 ]; then
            echo "expected LANG=C.UTF-8 in the default image" >&2
            exit 1
        fi
    fi

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

if docker run --rm "$image" sh -c 'command -v ffmpeg >/dev/null 2>&1'; then
    echo "ffmpeg must not be installed in $variant image" >&2
    exit 1
fi

image_size_bytes=$(docker image inspect --format '{{.Size}}' "$image")
printf 'image size reported by Docker: %s bytes\n' "$image_size_bytes"
