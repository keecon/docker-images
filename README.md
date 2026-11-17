# docker-images

[![gradle](https://github.com/keecon/docker-images/actions/workflows/gradle.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/gradle.yml)
[![minio](https://github.com/keecon/docker-images/actions/workflows/minio.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/minio.yml)
[![node](https://github.com/keecon/docker-images/actions/workflows/node.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/node.yml)
[![open-telemetry](https://github.com/keecon/docker-images/actions/workflows/open-telemetry2-jdk21.yml/badge.svg)](https://github.com/keecon/docker-images/actions/workflows/open-telemetry2-jdk21.yml)
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

- OpenTelemetry Java Agent 1.x, JDK 11 전용 이미지와 Tomcat 전용 이미지는 이 저장소에서 신규 빌드·배포 및 보안 업데이트를 중단합니다. 기존 태그는 계속 사용할 수 있지만 업데이트되지 않습니다. 1.x 사용자는 2.x로, JDK 11 이미지 사용자는 관리 중인 JDK 버전으로 이전을 검토하세요. 1.x에는 RMI 원격 코드 실행 및 JDBC 비밀번호 노출 관련 취약점이 알려져 있습니다.
- Tomcat 사용자는 지원되는 Tomcat 이미지를 직접 관리하고 [Java Agent](https://opentelemetry.io/docs/zero-code/java/agent/getting-started/)를 설치해 JVM에 연결해야 합니다. 일반 JDK 이미지는 Tomcat을 포함하지 않습니다.
- 2.x는 JDK 17·21·25별로 독립적으로 검증·배포합니다. 해당 JDK Dockerfile 변경은 해당 워크플로만 실행하고, `otel-v2.env` 또는 공통 테스트 변경은 모든 JDK 워크플로를 실행합니다. 수동 실행 시 해당 JDK 워크플로를 선택합니다.

- OpenTelemetry 2.x는 최신 Temurin Java LTS 3개에 JDK와 JRE를 함께 지원합니다. 새로운 LTS를 추가하면 가장 오래된 LTS의 신규 빌드와 배포를 중단합니다. 실행 전용 환경에서도 같은 LTS를 선택할 수 있도록 기본(Noble)·Alpine·FFmpeg 변형을 동일하게 관리합니다.
- JDK/JRE는 같은 Temurin 패치·빌드 버전으로 고정하고 함께 갱신합니다. JRE는 해당 LTS의 Dockerfile을 재사용하며 `JAVA_BASE_TAG`로 선택합니다.
- 현재 2.x의 JDK/JRE 지원 대상은 Java 17, 21, 25입니다.
- LTS 추가·갱신 시 Dockerfile 기본 태그와 워크플로의 검증·배포 매트릭스를 함께 수정합니다. 베이스 이미지의 대상 아키텍처 지원을 확인하고, 기존 런타임 검사(Java·Agent 버전, JDK의 `javac` 존재/JRE의 부재, 변형별 기능)와 다중 아키텍처 빌드가 통과한 뒤 배포합니다.
- 이미지 크기는 기록만 하며 배포 통과 여부에 사용하지 않습니다.
- FFmpeg 변형은 Ubuntu Noble을 유지합니다. 2026-09-30 현재 [CVE-2026-93990의 Noble `expat` 상태](https://ubuntu.com/security/CVE-2026-93990)는 `Needs evaluation`입니다. Ubuntu 보안 패키지가 이 CVE를 수정했다고 확인되면 OpenTelemetry 2.x의 JDK/JRE FFmpeg 이미지를 다시 빌드하고 최종 이미지의 패키지 버전과 보안 공지를 대조합니다.

### public docker base images

[![docker:lipanski/docker-static-website](https://img.shields.io/docker/v/lipanski/docker-static-website?logo=docker&label=lipanski%2Fdocker-static-website)](https://hub.docker.com/r/lipanski/docker-static-website/tags)
