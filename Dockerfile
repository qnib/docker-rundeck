FROM qnib/alplain-jre8

ENV RUNDECK_SERVER_HOST=localhost \
    RUNDECK_SERVER_PORT=4440

RUN apk --no-cache add openssl \
 && mkdir -p /opt/rundeck/ \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "# confd: $(/usr/local/bin/go-github rLatestUrl --ghorg kelseyhightower --ghrepo confd --regex ".*linux-amd64$" |head -n1)" \
 && wget -qO /usr/local/bin/confd $(/usr/local/bin/go-github rLatestUrl --ghorg kelseyhightower --ghrepo confd --regex ".*linux-amd64$" |head -n1) \
 && chmod +x /usr/local/bin/confd \
 && echo "# rundeck: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo rundeck --regex 'rundeck\-launcher\-[0-9\.]+\-SNAPSHOT\.jar$' |head -n1)" \
 && wget -qO /opt/rundeck/rundeck-launcher.jar $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo rundeck --regex "rundeck\-launcher\-[0-9\.]+\-SNAPSHOT\.jar$" |head -n1) \
 && rm -f /usr/local/bin/go-github
ADD opt/qnib/rundeck/bin/start.sh \
    opt/qnib/rundeck/bin/healthcheck.sh \
    /opt/qnib/rundeck/bin/
ADD etc/confd/conf.d/rundeck.toml /etc/confd/conf.d/
ADD etc/confd/templates/rundeck-config.properties.tmpl /etc/confd/templates/
#ADD opt/rundeck/server/config/rundeck-config.properties /opt/rundeck/server/config/
ADD opt/qnib/entry/rundeck/config.sh /opt/qnib/entry/rundeck/
CMD ["/opt/qnib/rundeck/bin/start.sh"]
