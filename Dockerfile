# syntax=docker/dockerfile:1

ARG BUILD_FROM=lscr.io/linuxserver/qbittorrent:4.6.3-r0-ls311

FROM ${BUILD_FROM} 

# set version label
ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_EXT_RELEASE="v2.7.0"
LABEL build_version="Chukyserver.io version:- ${BUILD_VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chukysoria"
# hard set UTC in case the user does not define it
ENV TZ="Etc/UTC"

# environment settings
ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

# install vuetorrent
RUN \
  echo "***** install vuetorrent ****" && \
  mkdir /vuetorrent && \
  curl -o \
    /tmp/vuetorrent.zip -L \
    "https://github.com/WDaan/VueTorrent/releases/download/${BUILD_EXT_RELEASE}/vuetorrent.zip" && \
  unzip \
    /tmp/vuetorrent.zip -d \
    /vuetorrent && \
  echo "**** cleanup ****" && \
  rm -rf \
    /root/.cache \
    /tmp/*

# ports and volumes
EXPOSE 8080 6881 6881/udp

VOLUME /config

HEALTHCHECK --interval=30s --timeout=30s --start-period=2m --start-interval=5s --retries=5 CMD ["nc", "-z", "localhost", "8080"]
