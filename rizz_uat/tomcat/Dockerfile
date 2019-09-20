FROM tomcat:8.5.38-jre8

MAINTAINER Rizwan khan

ENV GITHUB_REPO https://github.com/rizwankhan1787/thoughtworks_assignment/artefacts
ENV APP_FILE companyNews.war
ENV TERM xterm
ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom

RUN apt-get update -qq \
  && apt-get install -qqy curl wget \
  && apt-get clean \
  \
  && touch /var/log/companyNews.log \
  && chmod 666 /var/log/companyNews.log
RUN rm -rf /usr/local/tomcat/webapps/ROOT*
COPY companyNews.war /usr/local/tomcat/webapps/ROOT.war
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
CMD chmod +x /usr/local/tomcat/bin/catalina.sh
CMD [ "/usr/local/tomcat/bin/catalina.sh", "stop" ]
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
# install Filebeat
ENV FILEBEAT_VERSION=filebeat_1.2.3_amd64.deb
RUN curl -L -O https://download.elastic.co/beats/filebeat/${FILEBEAT_VERSION} \
 && dpkg -i ${FILEBEAT_VERSION} \
 && rm ${FILEBEAT_VERSION}

# configure Filebeat
ADD filebeat.yml /etc/filebeat/filebeat.yml

# CA cert
RUN mkdir -p /etc/pki/tls/certs
ADD logstash-beats.crt /etc/pki/tls/certs/logstash-beats.crt

# start Filebeat
ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
