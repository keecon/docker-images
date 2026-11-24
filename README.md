# docker-images

## OpenTelemetry Java Agent

[![JDK 25](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2025&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk17*,*-jdk21*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)
[![JDK 21](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2021&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk17*,*-jdk25*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)
[![JDK 17](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2017&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk21*,*-jdk25*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)

- Agent 2.x와 Temurin Java LTS 25·21·17을 관리합니다.
  - 각 버전은 JDK·JRE 기본(Debian 13 slim) 이미지와 FFmpeg 이미지를 제공합니다.
  - 기본 이미지의 JDK는 distroless와 같은 Adoptium Debian 저장소의 Temurin이며, 셸과 coreutils를 포함합니다.
  - JRE는 Debian 13 기반 distroless 이미지도 제공합니다: `2-jre25-distroless`, `2-jre21-distroless`, `2-jre17-distroless`.
  - Distroless 이미지에는 셸이 없으며, 베이스 이미지 갱신을 반영하려면 재빌드해야 합니다.
- 모든 이미지의 기본 사용자는 root이며, `nonroot`(uid/gid 65532) 사용자가 함께 존재합니다.
  - 필요하면 `USER nonroot`, `docker run --user 65532` 또는 Kubernetes `runAsUser: 65532`로 전환하세요.
- 배지는 각 JDK 기본 이미지의 최신 배포 태그입니다.
  - `2-jdk25`, `2-jdk21`, `2-jdk17` 태그도 사용할 수 있습니다.
- 새 Java LTS를 추가하면 가장 오래된 LTS의 신규 빌드와 배포를 중단합니다.
  - 기존 Temurin JDK와 JRE는 같은 패치·빌드 버전으로 함께 갱신합니다. Distroless는 별도의 베이스 이미지 갱신 주기를 따릅니다.
- FFmpeg 이미지는 Debian 13 distroless와 Debian FFmpeg 패키지를 사용합니다.
- `jdkXX-alpine`, `jreXX-alpine`, `jdkXX-ffmpeg` 태그의 신규 배포는 중단했으며 기존 태그는 갱신되지 않습니다.

## 관리하지 않는 이미지

- Gradle
- MinIO, MinIO Client
- Node.js
- PostgreSQL
- Microsoft SQL Server
- TCP Proxy
- OpenTelemetry Agent 1.x
- JDK 11 이하 및 Tomcat 전용 이미지

> Agent 1.x, JDK 11 및 Tomcat 전용 이미지는 신규 빌드와 배포도 중단했습니다. 관련 파일은 `open-telemetry/old/`에 보관하며 유지·검증하지 않습니다.
> Tomcat은 지원되는 이미지를 직접 관리하고 [Java Agent](https://opentelemetry.io/docs/zero-code/java/agent/getting-started/)를 설치하세요.

지원이 종료된 OpenTelemetry 이미지의 전용 파일과 비활성화한 워크플로는 `open-telemetry/old/`에 보관합니다. 지원 중인 이미지가 함께 사용하는 공통 파일은 원래 위치에 유지합니다.
