FROM nginx:latest

RUN apt-get update -qq \
&& apt-get install -qqy unzip curl wget nano \
&& apt-get clean
ADD static.zip /tmp/
RUN unzip -d /usr/share/nginx/assets/ /tmp/static.zip \
    && rm -rf /tmp/static.zip
COPY default.conf /etc/nginx/conf.d/default.conf
RUN rm /var/log/nginx/access.log /var/log/nginx/error.log

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
