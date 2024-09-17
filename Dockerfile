# FROM ghcr.io/actions/actions-runner:2.317.0
FROM ghcr.io/actions/actions-runner:latest

LABEL org.opencontainers.image.authors="Emmanuel BRUNO (@emmanuelbruno)" \
      org.opencontainers.image.description="An debian based runner image for Java in GitHub Actions" \
      org.opencontainers.image.documentation="https://github.com/ebpro/dev-runner-java/README.md" \
      org.opencontainers.image.license="MIT" \
      org.opencontainers.image.path="Dockerfile" \
      org.opencontainers.image.source="https://github.com/ebpro/dev-runner-java" \
      org.opencontainers.image.support="https://github.com/ebpro/dev-runner-java/issues" \
      org.opencontainers.image.title="Dev Runner Java" \
      org.opencontainers.image.vendor="UTLN" \
      org.opencontainers.image.version="0.1.0"

USER root

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        curl \
        jq \
        git \
        gpg \
        openssh-client \
        unzip \
        wget \
        zip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

USER runner

ENV SDKMAN_DIR=/home/runner/.sdkman \
    JAVA_VERSION=21.0.3-tem \
    MAVEN_VERSION=3.9.8 \
    MVND_VERSION=1.0.1 \
    GRADLE_VERSION=8.8 \
    KOTLIN_VERSION=2.0.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Installs Java development tools (Java, Kotlin, Gradle, Maven) via SDKMAN and configures the environment
RUN curl -s "https://get.sdkman.io" | bash && \
    chmod a+x "${SDKMAN_DIR}/bin/sdkman-init.sh" && \
    echo "sdkman_auto_answer=true\nsdkman_auto_selfupdate=false\nsdkman_insecure_ssl=false" > ${SDKMAN_DIR}/etc/config && \
    source "${SDKMAN_DIR}/bin/sdkman-init.sh" && \
    sdk install java ${JAVA_VERSION} && \
    sdk install kotlin ${KOTLIN_VERSION} && \
    sdk install gradle ${GRADLE_VERSION} && \
    sdk install maven ${MAVEN_VERSION} && \
    # sdk install mvnd ${MVND_VERSION} && \
    sdk flush archives

