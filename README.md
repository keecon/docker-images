# docker-images

## OpenTelemetry Java Agent

[![JDK 25](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2025&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk17*,*-jdk21*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)
[![JDK 21](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2021&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk17*,*-jdk25*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)
[![JDK 17](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2017&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk21*,*-jdk25*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)

- Agent 2.x와 Temurin Java LTS 25·21·17을 관리합니다.
  - 각 버전은 JDK·JRE와 기본(Noble)·Alpine·FFmpeg 이미지를 제공합니다.
- 배지는 각 JDK 기본 이미지의 최신 배포 태그입니다.
  - `2-jdk25`, `2-jdk21`, `2-jdk17` 태그도 사용할 수 있습니다.
- 새 Java LTS를 추가하면 가장 오래된 LTS의 신규 빌드와 배포를 중단합니다.
  - JDK와 JRE는 같은 Temurin 패치·빌드 버전으로 함께 갱신합니다.
- FFmpeg 이미지는 Ubuntu Noble을 사용합니다.

## 관리하지 않는 이미지

- Gradle
- MinIO, MinIO Client
- Node.js
- PostgreSQL
- Microsoft SQL Server
- TCP Proxy
- OpenTelemetry Agent 1.x
- JDK 11 이하 및 Tomcat 전용 이미지

> Agent 1.x, JDK 11 및 Tomcat 전용 이미지는 신규 빌드와 배포도 중단했습니다.
> Tomcat은 지원되는 이미지를 직접 관리하고 [Java Agent](https://opentelemetry.io/docs/zero-code/java/agent/getting-started/)를 설치하세요.
