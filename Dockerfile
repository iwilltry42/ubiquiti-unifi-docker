ARG DEBIAN_VERSION=stretch
FROM debian:${DEBIAN_VERSION}-slim
LABEL maintainer="Thorsten Klein <iwilltry42@gmail.com>"

ARG CONFD_REPO=iwilltry42/confd
ARG CONFD_VERSION=0.16.1
ARG OS=linux
ARG ARCH=amd64

ARG DEBIAN_VERSION
ARG UNIFI_VERSION
ARG UNIFI_REPO_LINE="deb https://www.ui.com/downloads/unifi/debian stable ubiquiti"
ARG MONGODB_VERSION="3.6"
ARG MONGODB_REPO_LINE="deb https://repo.mongodb.org/apt/debian ${DEBIAN_VERSION}/mongodb-org/${MONGODB_VERSION} main"

ENV BUILD_DEPS="ca-certificates apt-transport-https wget gnupg"
ENV UNIFI_DEPS="openjdk-8-jre-headless"
ENV RUN_DEPS="multitail"
ENV UNIFI_REPO_LINE=${UNIFI_REPO_LINE}
ENV MONGODB_REPO_LINE=${MONGODB_REPO_LINE}
ENV MONGODB_VERSION=${MONGODB_VERSION}

# Setup directories
# - /usr/share/man/man1 -> to fix install issues of openjdk-8-jre-headless
# - /etc/confd and /usr/lib/unifi/data/ -> source and destination directories for confd
RUN mkdir -p /usr/share/man/man1 /etc/confd /usr/lib/unifi/data/

COPY unifi/entrypoint.sh /bin/entrypoint.sh
COPY unifi/templates /etc/confd/templates/
COPY unifi/conf.d /etc/confd/conf.d/

RUN apt-get update && \
  apt-get install -yq ${UNIFI_DEPS} && \
  apt-get install -yq ${BUILD_DEPS} && \
  apt-get install -yq ${RUN_DEPS} && \
  echo "${UNIFI_REPO_LINE}" | tee /etc/apt/sources.list.d/100-ubnt-unifi.list && \
  wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg  && \
  wget -qO - https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc | apt-key add - && \
  echo "${MONGODB_REPO_LINE}" | tee /etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list && \
  apt-get update && \
  apt-mark hold openjdk-* && \
  apt-get update && \
  apt-get install unifi -y && \
  apt-get autoremove -y && \
  mkdir -p /etc/confd && \
  wget "https://github.com/${CONFD_REPO}/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-${OS}-${ARCH}" -O /usr/bin/confd && \
  chmod +x /usr/bin/confd

EXPOSE 8080 8443 8843 8880

ENTRYPOINT [ "bash", "-c" ]

CMD [ "/bin/entrypoint.sh" ]
