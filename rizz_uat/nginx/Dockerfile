# NGINX image with build artifact

FROM nginx:latest

MAINTAINER Rizwan khan

ENV GITHUB_REPO https://github.com/rizwankhan1787/thoughtworks_assignment/blob/master/artifacts
ENV STATIC_FILE static.zip
RUN apt-get update -qq \
  && apt-get install -qqy curl wget unzip nano p7zip-full \
  && apt-get clean \
COPY ../artifacts/static.zip /usr/share/nginx/assets/ \

COPY default.conf /etc/nginx/conf.d/default.conf

# tweak nginx image set-up, remove log symlinks
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
