##############################################################################
# Dockerfile to build Atlassian Fisheye/Crucible container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ARG VERSION

ENV FECRU_INST /opt/atlassian/fecru
ENV FECRU_HOME /var/opt/atlassian/application-data/fecru
ENV SYSTEM_USER fecru
ENV SYSTEM_GROUP fecru
ENV SYSTEM_HOME /home/fecru

RUN set -x \
  && apk add openssh git unzip xmlstarlet wget ca-certificates --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p ${FECRU_INST} \
  && mkdir -p ${FECRU_HOME}

RUN set -x \
  && mkdir -p /home/${SYSTEM_USER} \
  && addgroup -S ${SYSTEM_GROUP} \
  && adduser -S -D -G ${SYSTEM_GROUP} -h ${SYSTEM_GROUP} -s /bin/sh ${SYSTEM_USER} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /home/${SYSTEM_USER}

RUN set -x \
  && wget -nv -O /tmp/fisheye-${VERSION}.zip https://www.atlassian.com/software/fisheye/downloads/binary/fisheye-${VERSION}.zip \
  && unzip /tmp/fisheye-${VERSION}.zip -d /tmp/ \
  && mv /tmp/fecru-${VERSION}/* ${FECRU_INST} \
  && rm -rf /tmp/fecru-${VERSION} \
  && rm /tmp/fisheye-${VERSION}.zip \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${FECRU_INST} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${FECRU_HOME}

RUN set -x \
  && touch -d "@0" "${FECRU_INST}/config.xml" \
  && touch -d "@0" "${FECRU_INST}/bin/fisheyectl.sh"

ADD files/service /usr/local/bin/service
ADD files/entrypoint /usr/local/bin/entrypoint

RUN set -x \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /usr/local/bin/service \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /usr/local/bin/entrypoint

EXPOSE 8060

USER ${SYSTEM_USER}

VOLUME ${FECRU_HOME}

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["/usr/local/bin/service"]
