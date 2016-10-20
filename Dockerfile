FROM qnib/alplain-jre8

ENV RUNDECK_SERVER_HOST=localhost \
    RUNDECK_SERVER_PORT=4440 \
    RUNDECK_LOG_LEVEL=info

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
ADD etc/confd/conf.d/jaas-loginmodule.toml \
    etc/confd/conf.d/realm.toml \
    etc/confd/conf.d/rundeck-config.toml \
    /etc/confd/conf.d/
ADD etc/confd/templates/rundeck-config.properties.tmpl \
    etc/confd/templates/jaas-loginmodule.conf.tmpl \
    etc/confd/templates/realm.properties.tmpl \
    /etc/confd/templates/
ADD opt/qnib/entry/10-rundeck/config.sh /opt/qnib/entry/10-rundeck/
CMD ["/opt/qnib/rundeck/bin/start.sh"]
#RUN chown user: /opt/rundeck/rundeck-launcher.jar \
#&& for d in server/exp server/lib tools;do mkdir -p /opt/rundeck/${d} ; chown -R user: /opt/rundeck/${d} ;done
