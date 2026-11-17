# docker-images

## OpenTelemetry Java Agent

[![JDK 25](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2025&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk17*,*-jdk21*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)
[![JDK 21](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2021&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk17*,*-jdk25*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)
[![JDK 17](https://ghcr-badge.egpl.dev/keecon/open-telemetry/latest_tag?label=JDK%2017&ignore=2-*,*-jre*,*-alpine,*-ffmpeg,*tomcat*,*-jdk21*,*-jdk25*)](https://github.com/orgs/keecon/packages/container/package/open-telemetry)

- Agent 2.x와 Temurin Java LTS 25·21·17을 관리합니다. 각 버전은 JDK·JRE와 기본(Noble)·Alpine·FFmpeg 이미지를 제공합니다.
- 배지는 각 JDK 기본 이미지의 최신 배포 태그입니다. `2-jdk25`, `2-jdk21`, `2-jdk17` 태그도 사용할 수 있습니다. 전체 태그는 배지의 패키지 링크에서 확인하세요.
- 새 Java LTS를 추가하면 가장 오래된 LTS의 신규 빌드와 배포를 중단합니다. JDK와 JRE는 같은 Temurin 패치·빌드 버전으로 함께 갱신합니다.
- Java 버전별로 독립적으로 검증·배포합니다. 공통 설정이나 테스트가 바뀌면 모든 버전을 검증합니다. LTS 갱신 시 대상 아키텍처, 런타임 검사와 다중 아키텍처 빌드를 확인합니다.
- FFmpeg 이미지는 Ubuntu Noble을 사용합니다. 2026-09-30 기준 [CVE-2026-93990의 Noble `expat` 상태](https://ubuntu.com/security/CVE-2026-93990)는 `Needs evaluation`입니다. 수정이 확인되면 FFmpeg 이미지를 다시 빌드하고 최종 패키지 버전을 보안 공지와 대조합니다.

## 관리하지 않는 이미지

- Gradle, MinIO, MinIO Client, Node.js, PostgreSQL, Microsoft SQL Server, TCP Proxy
- OpenTelemetry Agent 1.x, JDK 11 전용 및 Tomcat 전용 이미지

위 이미지는 유지보수와 보안 업데이트를 제공하지 않습니다. 기존 워크플로가 남아 있어도 관리 대상은 아닙니다. Agent 1.x, JDK 11 및 Tomcat 전용 이미지는 신규 빌드와 배포도 중단했습니다. Agent 1.x에는 RMI 원격 코드 실행 및 JDBC 비밀번호 노출 관련 취약점이 알려져 있으므로 Agent 2.x와 지원되는 Java 버전으로 이전을 검토하세요. Tomcat은 지원되는 이미지를 직접 관리하고 [Java Agent](https://opentelemetry.io/docs/zero-code/java/agent/getting-started/)를 설치하세요.
