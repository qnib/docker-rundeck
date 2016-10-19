FROM qnib/alpn-jre8

RUN apk --no-cache add openssl \
 && mkdir -p /opt/rundeck/libs/ \
 && cd /opt/rundeck/libs/ \
 && wget -q https://github.com/qnib/rundeck/releases/download/v2.6.10/rundeck-launcher-2.6.10-SNAPSHOT.jar
