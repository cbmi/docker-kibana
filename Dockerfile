FROM stackbrew/ubuntu:trusty
MAINTAINER Le Mar Davidson <davidsonl2@email.chop.edu>

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget nginx-full apache2-utils supervisor

WORKDIR /opt
#RUN wget --no-check-certificate -O- https://download.elasticsearch.org/kibana/kibana/kibana-3.0.1.tar.gz | tar xvfz -
ADD kibana /opt/kibana
ADD config/config.js /opt/kibana/config.js
RUN mkdir /etc/kibana # This is where the htpasswd file is placed by the run script

ADD nginx_config /opt/nginx_config
RUN chmod +x /opt/nginx_config

ADD config/etc /etc
RUN rm /etc/nginx/sites-enabled/*
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ENV KIBANA_SECURE true
ENV KIBANA_USER kibana
ENV KIBANA_PASSWORD kibana

EXPOSE 80

ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
