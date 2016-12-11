##############################################################################
# Dockerfile to build Atlassian Fisheye/Crucible container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ARG VERSION

ENV FECRU_INST /opt/atlassian/fecru
ENV FECRU_HOME /var/opt/atlassian/application-data/fecru

RUN set -x \
  && apk add git unzip xmlstarlet --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p $FECRU_INST \
  && mkdir -p $FECRU_HOME

ADD https://www.atlassian.com/software/fisheye/downloads/binary/fisheye-$VERSION.zip /tmp

RUN set -x \
  && unzip /tmp/fisheye-$VERSION.zip -d /tmp/ \
  && mv /tmp/fecru-$VERSION/* $FECRU_INST \
  && rm -rf /tmp/fecru-$VERSION \
  && rm /tmp/fisheye-$VERSION.zip

RUN set -x \
  && touch -d "@0" "$FECRU_INST/config.xml" \
  && touch -d "@0" "$FECRU_INST/bin/fisheyectl.sh"

ADD files/entrypoint /usr/local/bin/entrypoint

RUN set -x \
  && chown -R daemon:daemon /usr/local/bin/entrypoint \
  && chown -R daemon:daemon $FECRU_INST \
  && chown -R daemon:daemon $FECRU_HOME

EXPOSE 8060

USER daemon

ENTRYPOINT  ["/usr/local/bin/entrypoint"]
