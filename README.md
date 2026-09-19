# docker-images

[![gradle](https://github.com/keecon/docker-images/actions/workflows/gradle.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/gradle.yml)
[![minio](https://github.com/keecon/docker-images/actions/workflows/minio.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/minio.yml)
[![node](https://github.com/keecon/docker-images/actions/workflows/node.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/node.yml)
[![open-telemetry](https://github.com/keecon/docker-images/actions/workflows/open-telemetry.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/open-telemetry.yml)
[![postgres](https://github.com/keecon/docker-images/actions/workflows/postgres.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/postgres.yml)
[![mssql](https://github.com/keecon/docker-images/actions/workflows/mssql.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/mssql.yml)
[![tcp-proxy](https://github.com/keecon/docker-images/actions/workflows/tcp-proxy.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/gradle.yml)

### project docker base images

[![gradle](https://ghcr-badge.egpl.dev/keecon/gradle/tags?trim=major&label=gradle)](https://github.com/orgs/keecon/packages/container/package/gradle)![size](https://ghcr-badge.egpl.dev/keecon/gradle/size?tag=5-jdk8)

[![minio](https://ghcr-badge.egpl.dev/keecon/minio/tags?trim=major&label=minio)](https://github.com/orgs/keecon/packages/container/package/minio)![size](https://ghcr-badge.egpl.dev/keecon/minio/size?tag=2021)

[![minio-client](https://ghcr-badge.egpl.dev/keecon/minio-client/tags?trim=major&label=minio-client)](https://github.com/orgs/keecon/packages/container/package/minio-client)![size](https://ghcr-badge.egpl.dev/keecon/minio-client/size?tag=2021)

[![open-telemetry](https://ghcr-badge.egpl.dev/keecon/open-telemetry/tags?trim=major&label=open-telemetry)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)![size](https://ghcr-badge.egpl.dev/keecon/open-telemetry/size?tag=2-jdk21)

[![node](https://ghcr-badge.egpl.dev/keecon/node/tags?trim=major&label=node)](https://github.com/orgs/keecon/packages/container/package/node)![size](https://ghcr-badge.egpl.dev/keecon/node/size?tag=18)

[![postgres](https://ghcr-badge.egpl.dev/keecon/postgres/tags?trim=major&label=postgres)](https://github.com/orgs/keecon/packages/container/package/postgres)![size](https://ghcr-badge.egpl.dev/keecon/postgres/size?tag=14)

[![mssql](https://ghcr-badge.egpl.dev/keecon/mssql/tags?trim=major&label=mssql)](https://github.com/orgs/keecon/packages/container/package/mssql)![size](https://ghcr-badge.egpl.dev/keecon/mssql/size?tag=2022)

[![tcp-proxy](https://ghcr-badge.egpl.dev/keecon/tcp-proxy/tags?trim=major&label=tcp-proxy)](https://github.com/orgs/keecon/packages/container/package/tcp-proxy)![size](https://ghcr-badge.egpl.dev/keecon/tcp-proxy/size?tag=1)

### OpenTelemetry Java 버전 관리 정책

- OpenTelemetry 2.x에 새로운 최신 Java LTS를 추가할 때는 JDK와 JRE를 함께 지원합니다. 실행 전용 환경에서도 같은 LTS를 선택할 수 있도록 기본(Noble)·Alpine·FFmpeg 변형을 동일하게 관리합니다.
- JDK/JRE는 같은 Temurin 패치·빌드 버전으로 고정하고 함께 갱신합니다. JRE는 해당 LTS의 Dockerfile을 재사용하며 `JAVA_BASE_TAG`로 선택합니다.
- 현재 2.x의 JDK/JRE 동시 지원 대상은 Java 21과 25입니다. 기존 Java 11·17과 OpenTelemetry 1.x의 지원 범위는 유지합니다.
- LTS 추가·갱신 시 Dockerfile 기본 태그와 워크플로의 검증·배포 매트릭스를 함께 수정합니다. 베이스 이미지의 대상 아키텍처 지원을 확인하고, 기존 런타임 검사(Java·Agent 버전, JDK의 `javac` 존재/JRE의 부재, 변형별 기능·크기)와 다중 아키텍처 빌드가 통과한 뒤 배포합니다.

### public docker base images

[![docker:lipanski/docker-static-website](https://img.shields.io/docker/v/lipanski/docker-static-website?logo=docker&label=lipanski%2Fdocker-static-website)](https://hub.docker.com/r/lipanski/docker-static-website/tags)
