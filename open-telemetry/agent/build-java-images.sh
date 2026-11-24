#!/bin/sh
set -eu

if [ "$#" -ne 4 ]; then
    echo "usage: $0 <java-major> <temurin-version> <publish:true|false> <variant>" >&2
    exit 2
fi
java_major=$1
temurin_version=$2
publish=$3
image_variant=$4
case "$java_major:$publish" in
    17:true|17:false|21:true|21:false|25:true|25:false) ;;
    *) echo "unsupported Java version or publish flag" >&2; exit 2 ;;
esac
: "${OTEL_VERSION:?}" "${OTEL_SHA256:?}"
agent_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

platforms=linux/amd64,linux/arm64
case "$image_variant" in
    distroless) suffix=jre${java_major}-distroless; dockerfile=distroless; java_kind=jre; variant=distroless; java_base_tag=gcr.io/distroless/java${java_major}-debian13:latest ;;
    jdk|jre) suffix=${image_variant}${java_major}; dockerfile=; java_kind=$image_variant; variant=plain; java_base_tag=${temurin_version}-${image_variant}-resolute ;;
    jre-alpine) java_kind=jre; suffix=${java_kind}${java_major}-alpine; dockerfile=alpine; variant=alpine; java_base_tag=${temurin_version}-${java_kind}-alpine
        if [ "$java_major" = 17 ]; then platforms=linux/amd64; fi ;;
    ffmpeg) suffix=jre${java_major}-ffmpeg; dockerfile=ffmpeg; java_kind=jre; variant=distroless-ffmpeg; java_base_tag=gcr.io/distroless/java${java_major}-debian13:latest ;;
    *) echo "unsupported image variant: $image_variant" >&2; exit 2 ;;
esac
image=local/open-telemetry:${OTEL_VERSION}-${suffix}
docker buildx build --platform "$platforms" --load --pull \
    --file "$agent_dir/Dockerfile${dockerfile:+.$dockerfile}" \
    --build-arg "JAVA_BASE_TAG=$java_base_tag" \
    --build-arg "OTEL_VERSION=$OTEL_VERSION" \
    --build-arg "OTEL_SHA256=$OTEL_SHA256" \
    --tag "$image" "$agent_dir"
DOCKER_DEFAULT_PLATFORM=linux/amd64 "$agent_dir/test-java-image.sh" "$image" "$OTEL_VERSION" "$java_major" "$java_kind" "$variant"
if [ "$platforms" != linux/amd64 ]; then
    DOCKER_DEFAULT_PLATFORM=linux/arm64 "$agent_dir/test-java-image.sh" "$image" "$OTEL_VERSION" "$java_major" "$java_kind" "$variant"
fi

if [ "$publish" = true ]; then
    for version in "$OTEL_VERSION" 2; do
        target=ghcr.io/keecon/open-telemetry:${version}-${suffix}
        docker tag "$image" "$target"
        docker push "$target"
    done
fi
