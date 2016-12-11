##############################################################################
# Dockerfile to build Atlassian Fisheye/Crucible container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ENV VERSION 0.0.0

RUN set -x \
  && apk add git unzip xmlstarlet --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p /opt/atlassian/fecru \
  && mkdir -p /var/opt/atlassian/application-data/fecru

ADD https://www.atlassian.com/software/fisheye/downloads/binary/fisheye-$VERSION.zip /tmp

RUN set -x \
  && unzip /tmp/fisheye-$VERSION.zip -d /tmp/ \
  && mv /tmp/fecru-$VERSION/* /opt/atlassian/fecru \
  && rm -rf /tmp/fecru-$VERSION \
  && rm /tmp/fisheye-$VERSION.zip

RUN set -x \
  && touch -d "@0" "/opt/atlassian/fecru/config.xml" \
  && touch -d "@0" "/opt/atlassian/fecru/bin/fisheyectl.sh"

ADD files/entrypoint /usr/local/bin/entrypoint

RUN set -x \
  && chown -R daemon:daemon /usr/local/bin/entrypoint \
  && chown -R daemon:daemon /opt/atlassian/fecru \
  && chown -R daemon:daemon /var/opt/atlassian/application-data/fecru

EXPOSE 8060

USER daemon

ENTRYPOINT  ["/usr/local/bin/entrypoint"]
