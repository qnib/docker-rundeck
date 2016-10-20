FROM qnib/alplain-jre8

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
#ADD opt/rundeck/etc/admin.aclpolicy \
#    opt/rundeck/etc/apitoken.aclpolicy \
#    opt/rundeck/etc/cli-log4j.properties \
#    opt/rundeck/etc/framework.properties \
#    opt/rundeck/etc/preferences.properties \
#    opt/rundeck/etc/profile \
#    opt/rundeck/etc/profile.bat \
#    opt/rundeck/etc/project.properties \
#    /opt/rundeck/etc/
ADD opt/rundeck/server/config/rundeck-config.properties /opt/rundeck/server/config/
ADD opt/qnib/rundeck/bin/start.sh /opt/qnib/rundeck/bin/
